grunt-find [![Build Status](https://travis-ci.org/hurrymaplelad/grunt-find.png)](https://travis-ci.org/hurrymaplelad/grunt-find)
=========

Faster dynamic file expansion.  Search thousands of files in milliseconds instead of decaseconds.  Filter by modification time.  Backed by [`find`](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/find.1.html)

```shell
npm install --save-dev grunt-find
```

Example
-------

```js
grunt.loadNpmTasks('grunt-find');
grunt.loadNpmTasks('grunt-contrib-coffee');

grunt.initConfig({
  find: {
    coffee: {
      name: '*.coffee',
      prune: 'node_module',
      expand: true,
      dest: 'lib/',
      ext: '.js',
      config: 'coffee.all.files'
    }
  },
});

grunt.registerTask('default', ['find:coffee', 'coffee']);
```

Check out the Gruntfile for more examples.

Configuration
-------------

#### name, prune, newer
Pattern(s) to match against filename path components.  `name` includes.  `prune` excludes.

#### config
Grunt config path to store matched files.  Set this to the file configuration of another task instead of configuring that task directly to speed up file matching.

#### cwd, dest, ext, expand
Same as [grunt](http://gruntjs.com/configuring-tasks#building-the-files-object-dynamically)
