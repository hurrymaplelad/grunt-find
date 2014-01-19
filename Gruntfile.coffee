module.exports = (grunt) ->
  grunt.config.init
    find:
      single:
        name: 'Gruntfile.coffee'

      multi:
        cwd: 'test/fixtures'
        name: '*.coffee'

      changed:
        expand: true
        name: '*.coffee'
        cnewer: 'test/fixtures/radish.coffee'

      # dest:
      #   name: 'Gruntfile.coffee'
      #   dest: 'Gruntfile.js'

      # destExpand:
      #   name: 'Gruntfile.coffee'
      #   expand: true
      #   dest: 'lib'
      #   ext: '.js'

      # config:
      #   config: 'test.results'

    touch:
      spelt: 'test/fixtures/grains/spelt.coffee'

    expected:
      single: files:[src: ['Gruntfile.coffee']]

      multi: files: [src: [
        'test/fixtures/beet.coffee'
        'test/fixtures/grains/spelt.coffee'
        'test/fixtures/radish.coffee'
      ]]

      changed: files: [src: ['test/fixtures/grains/spelt.coffee']]

  grunt.loadTasks 'tasks'
  grunt.loadNpmTasks 'grunt-touch'

  grunt.registerMultiTask 'expected', ->
    require 'should'
    foundFiles = grunt.config("find.#{@target}.files")
    if @target is 'changed'
      foundFiles.should.containEql @data.files[0]
    else
      foundFiles.should.eql @data.files

  grunt.registerTask 'test', [
    'touch:spelt'
    'find'
    'expected'
  ]
