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

      dest:
        name: 'Gruntfile.coffee'
        dest: 'Gruntfile.js'

      destExpand:
        name: 'Gruntfile.coffee'
        expand: true

        dest: 'lib/'
        ext: '.js'

      config:
        name: 'Gruntfile.coffee'
        config: 'find.configured.files'

    touch:
      spelt: 'test/fixtures/grains/spelt.coffee'

    expected:
      single: files:[src: ['Gruntfile.coffee']]

      multi: files: [src: [
        'test/fixtures/grains/spelt.coffee'
        'test/fixtures/kale.coffee'
        'test/fixtures/radish.coffee'
      ]]

      changed: files: [src: ['test/fixtures/grains/spelt.coffee']]

      dest: files: [src: 'Gruntfile.coffee', dest: 'Gruntfile.js']

      destExpand: files: [src: 'Gruntfile.coffee', dest: 'lib/Gruntfile.js']

      configured: files: [src: ['Gruntfile.coffee']]

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
