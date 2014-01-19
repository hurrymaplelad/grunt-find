pkg = require '../package.json'
{exec} = require 'child_process'
_ = require 'underscore'

module.exports = (grunt) ->
  grunt.registerMultiTask 'find', pkg.description, ->
    done = @async()
    {name, cwd, expand} = _(@data).defaults
      cwd: '.'

    command = "find #{cwd} -name '#{name}' -print"
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
