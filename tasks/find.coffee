pkg = require '../package.json'
_ = require 'underscore'
shellFind = require 'shell-find'

makeDestPath = (cwd, filename, prefix, ext) ->
  if filename.indexOf(cwd) is 0
    filename = filename.replace cwd, ''
  if ext
    filename = filename.replace /\.[^.]*$/, ext
  prefix + filename

module.exports = (grunt) ->
  # not a multitask to avoid default file expansion
  grunt.registerTask 'find', pkg.description, ->
    allConfig = grunt.config.getRaw @name
    [target] = @args

    # reproduce multitask behavior of running all targets by default
    unless target
      grunt.task.run Object.keys(allConfig).map (target) =>
        "#{@name}:#{target}"
      return

    done = @async()
    {name, newer, cwd, expand, prune, dest, ext, config} = _(allConfig[target]).defaults
      cwd: '.'
      config: "#{@name}.#{target}.files"

    finder = shellFind cwd
    if name
      [].concat(name).forEach (n) ->
        finder.name n
    if newer
      [].concat(newer).forEach (n) ->
        finder.newer n
    if prune
      [].concat(prune).forEach (p) ->
        finder.prune p

    grunt.log.verbose.writeln "# Running `#{finder.command()}`"

    finder.exec (err, filenames) =>
      if err
        grunt.fail.fatal err
        done(false)

      files = filenames
        .map (filename) ->
          filename.replace /^.\//, ''

      if expand
        files = files.map (filename) ->
          file = {src: [filename]}
          if dest
            file.dest = makeDestPath cwd, filename, dest, ext
          file

      else
        files = [{src: files}]
        if dest
          files[0].dest = dest

      grunt.config config, files
      done()
