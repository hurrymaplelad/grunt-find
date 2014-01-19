pkg = require '../package.json'
{exec} = require 'child_process'
_ = require 'underscore'
escape = require 'shell-escape'

module.exports = (grunt) ->
  grunt.registerMultiTask 'find', pkg.description, ->
    done = @async()
    {name, cwd, expand, cnewer} = _(@data).defaults
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
          {src: [filename]}
      else
        files = [{src: files}]

      grunt.config [@name, @target, 'files'], files
      done()
