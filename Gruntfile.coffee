module.exports = (grunt) ->
  grunt.config.init
    find:
      single:
        name: 'Gruntfile.coffee'

      multi:
        cwd: 'test/fixtures'
        name: '*.coffee'

      # changed:
      #   name: '*.coffee'
      #   cnewer: 'test/fixtures/grains/spelt.coffee'

      # destinationExpansion:
      #   dest: 'lib/'
      #   ext: '.js'

      # config:
      #   config: 'test.results'

    touch:
      spelt: 'test/fixtures/grains/spelt.coffee'
      radish: 'test/fixtures/radish.coffee'

    expected:
      single: files:[src: ['Gruntfile.coffee']]

      multi: files: [src: [
        'test/fixtures/beet.coffee'
        'test/fixtures/grains/spelt.coffee'
        'test/fixtures/radish.coffee'
      ]]

      # changed: files: [src: ['test/fixtures/radish.coffee']]

  grunt.loadTasks 'tasks'
  grunt.loadNpmTasks 'grunt-touch'

  grunt.registerMultiTask 'expected', ->
    require 'should'
    grunt.config("find.#{@target}.files").should.eql @data.files

  grunt.registerTask 'test', [
    'touch:spelt'
    'touch:radish'
    'find'
    'expected'
  ]
