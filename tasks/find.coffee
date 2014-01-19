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
    config = grunt.config.getRaw @name
    [target] = @args

    # reproduce multitask behavior of running all targets by default
    unless target
      grunt.task.run Object.keys(config).map (target) =>
        "#{@name}:#{target}"
      return

    done = @async()
    {name, cnewer, cwd, expand, dest, ext} = _(config[target]).defaults
      cwd: '.'

    command = ['find', cwd]
    if name
      command.push '-name', name
    if cnewer
      command.push '-cnewer', cnewer
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

      grunt.config [@name, target, 'files'], files
      done()
