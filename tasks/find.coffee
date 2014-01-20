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

    @data = allConfig[target]
    done = @async()
    {config, cwd, dest, expand, ext} = _(@data).defaults
      cwd: '.'
      config: "#{@name}.#{target}.files"

    finder = shellFind cwd
    methodCalls = _(@data).omit 'config', 'cwd', 'dest', 'expand', 'ext'
    for methodName, args of methodCalls
      [].concat(args).forEach (arg) ->
        if methodName is 'newer' and not grunt.file.exists arg
          grunt.log.verbose.writeln "newer file missing: #{arg}, skipped"
          return

        finder[methodName](arg)

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
