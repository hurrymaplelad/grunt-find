module.exports = (grunt) ->
  grunt.config.init
    find:
      single:
        name: 'find.coffee'

      multi:
        expand: true
        cwd: 'test/fixtures'
        name: '*.coffee'

      changed:
        expand: true
        name: '*.coffee'
        newer: 'test/fixtures/radish.coffee'

      missingNewer:
        expand: true
        name: '*.coffee'
        newer: 'does/not/exist'

      dest:
        name: 'Gruntfile.coffee'
        prune: 'node_modules'
        dest: 'Gruntfile.js'

      destExpand:
        name: 'find.coffee'
        expand: true

        dest: 'lib/'
        ext: '.js'

      config:
        name: 'find.coffee'
        config: 'find.configured.files'

    touch:
      spelt: 'test/fixtures/grains/spelt.coffee'

    expected:
      single: files:[src: ['tasks/find.coffee']]

      multi: files: [
        {src: ['test/fixtures/grains/spelt.coffee']}
        {src: ['test/fixtures/kale.coffee']}
        {src: ['test/fixtures/radish.coffee']}
      ]

      changed: files: [src: ['test/fixtures/grains/spelt.coffee']]

      dest: files: [src: 'Gruntfile.coffee', dest: 'Gruntfile.js']

      destExpand: files: [src: 'tasks/find.coffee', dest: 'lib/tasks/find.js']

      configured: files: [src: ['tasks/find.coffee']]

  grunt.loadTasks 'tasks'
  grunt.loadNpmTasks 'grunt-touch'

  grunt.registerMultiTask 'expected', ->
    require 'should'
    foundFiles = grunt.config("find.#{@target}.files")
    for file in @data.files
      foundFiles.should.containEql file

  grunt.registerTask 'test', [
    'touch:spelt'
    'find'
    'expected'
  ]
