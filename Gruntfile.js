var bower = require('bower'),
  path = require('path'),
  crypto = require('crypto'),
  async = require('async');

module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    jshint: {
      all: [
        'Gruntfile.js',
        'server/**/*.js',
        'test/**/*.js',
        'server/**/*.json',
        'test/**/*.json',
        'client/**/*.js',
        'client/**/*.json'
      ]
    },
    nodeunit: {
      all: ['test/server/**/*.js']
    },
    apidoc: {
      tgio: {
        src: "server/",
        dest: "build/www/apidoc/"
      }
    },
    bower: {
      target: {
        rjsConfig: 'client/www/js/config.js'
      }
    },
    requirejs: {
      prod: {
        options: {
          mainConfigFile: 'client/www/js/config.js',
          name: 'tgio',
          out: 'build/www/js/main.js',
          optimize: "none",
        },
      },
    },
    copy: {
      main: {
        files: [
          // includes files within path and its sub-directories
          {
            expand: true,
            src: ['**'],
            cwd: 'client/www/static/',
            dest: 'build/www'
          }, {
            expand: true,
            src: ['require.js'],
            cwd: 'bower_components/requirejs/',
            dest: 'build/www/js'
          }
        ]
      }
    },
    less: {
      development: {
        options: {
          paths: ["."]
        },
        files: {
          "build/www/css/main.css": "client/www/less/main.less"
        }
      }
    },
    watch: {
      scripts: {
        files: ['client/www/**', 'server/**', 'test/**'],
        tasks: ['default', 'express-restart'],
        options: {
          interrupt: true,
        },
      },
    },
    jsbeautifier: {
      "default": {
        src: ['Gruntfile.js', "server/**/*.js", "test/**/*.js", "server/**/*.json", "test/**/*.json", 'client/**/*.js', 'client/**/*.json'],
        options: {
          js: {
            indent_size: 2,
            "preserve_newlines": true,
            "max_preserve_newlines": 10,
            "jslint_happy": false,
          }
        }
      },
      "git-pre-commit": {
        src: ['Gruntfile.js', "server/**/*.js", "test/**/*.js", "server/**/*.json", "test/**/*.json", 'client/**/*.js', 'client/**/*.json'],
        options: {
          mode: "VERIFY_ONLY",
          js: {
            indent_size: 2,
            "preserve_newlines": true,
            "max_preserve_newlines": 10,
            "jslint_happy": false,
          }
        }
      }
    },
    express: {
      server: {
        options: {
          debug: true,
          verbose: true,
          hostname: '*',
          server: path.resolve(__dirname, 'server'),
          serverreload: true
        }
      }
    },
    encrypt: {
      default: {
        files: [{
          src: ["secure/*.json"],
          dest: "server",
          ext: ".json.encrypted",
          expand: true
        }],
        options: {
          keyfile: ".keyfile"
        }
      }
      /*,
      test: {
        files: [{
          src: ["test/secure/*.json"],
          ext: ".json.encrypted",
          expand: true
        }],
        options: {
          keyfile: ".testkeyfile"
        }
      }*/
    }
  });

  // A very basic default task.
  grunt.registerTask('sample', 'Log some stuff.', function() {
    grunt.log.write('Logging some stuff...').ok();
  });

  grunt.registerTask('bower-install', function() {
    var done = this.async();
    var install = bower.commands.install();

    function log(obj) {
      grunt.verbose.writeln(obj.id + ": " + obj.message);
    }
    install.on('log', log);
    install.on('error', grunt.log.error);
    install.on('end', done);
  });

  grunt.registerMultiTask('encrypt', function() {
    var options = this.options({
      "action": grunt.cli.options.crypt || "encrypt",
      "keyfile": grunt.cli.options.keyfile
    });
    var done = this.async();
    var key = grunt.file.read(options.keyfile);
    console.log(key);

    async.each(this.files, function(file, cb) {
        var text = grunt.file.read(file.src[0]),
          cipher = crypto.createCipher('aes-256-cbc', key),
          crypted = cipher.update(text, 'utf8', 'hex');

        crypted += cipher.final('hex');
        console.log(crypted);
        grunt.file.write(file.dest, crypted);
        grunt.log.writeln('Encrypting ' + file.src[0].cyan + ' -> ' + file.dest.cyan);
        cb();
      },
      function(result) {
        done(result);
      });
  });

  grunt.registerTask('build', ['encrypt', 'bower-install', 'bower', 'nodeunit', 'jshint', 'jsbeautifier', 'copy', 'requirejs', 'less', 'apidoc']);
  grunt.registerTask('server', ['express:server', 'build:default']);
  grunt.registerTask('default', 'build');
  grunt.registerTask('heroku:development', 'default');
  grunt.registerTask('heroku:', 'default');
  grunt.registerTask('heroku', 'default');
  grunt.loadNpmTasks('grunt-jsbeautifier');
  grunt.loadNpmTasks('grunt-apidoc');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-nodeunit');
  grunt.loadNpmTasks('grunt-bower-requirejs');
  grunt.loadNpmTasks('grunt-contrib-requirejs');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-express');
};
