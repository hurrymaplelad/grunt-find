pkg = require '../package.json'
{exec} = require 'child_process'
_ = require 'underscore'
escape = require 'shell-escape'

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
    {name, newer, cwd, expand, dest, ext, config} = _(allConfig[target]).defaults
      cwd: '.'
      config: "#{@name}.#{target}.files"

    command = ['find', cwd]
    if name
      command.push '-name', name
    if newer
      command.push '-newer', newer
    command.push '-print'
    command = escape command
    grunt.log.verbose.writeln "# Running `#{command}`"

    exec command, (err, stdout, stderr) =>
      if err or stderr
        grunt.fail.fatal err or sterr
        done(false)

      files = stdout
        .split('\n')
        .filter(Boolean)
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
