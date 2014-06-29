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
          name: 'main',
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
        files: ['client/www/**', 'server/**', 'test/**', '!server/secure/**'],
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
    // refactor these crpyts
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
    },
    jst: {
      compile: {
        options: {
          processName: function(filename) {
            return path.basename(path.relative('client/www/templates', filename), '.html');
          },
          amd: true
        },
        files: {
          "tmp/templates.js": ["client/www/templates/**/*.html"]
        }
      }
    },
    decrypt: {
      default: {
        files: [{
          cwd: "server/secure",
          src: ["*.json.encrypted"],
          dest: "secure",
          ext: ".json",
          expand: true
        }],
        options: {
          keyfile: ".keyfile"
        }
      }
    },
    bump: {
      options: {
        updateProps: {
          pkg: 'package.json'
        }
      },
      file: 'package.json'
    },
    env: {
      options: {
        //Shared Options Hash
      },
      dev: {
        NODE_ENV: 'development'
      }
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

    if (!process.env.KEY && !grunt.file.exists(options.keyfile)) {
      grunt.log.writeln("Key file " + options.keyfile + " does not exist.");
      return;
    }
    var done = this.async();

    var key = process.env.KEY || grunt.file.read(options.keyfile);

    async.each(this.files, function(file, cb) {
        var text = grunt.file.read(file.src[0]),
          cipher = crypto.createCipher('aes-256-cbc', key),
          crypted = cipher.update(text, 'utf8', 'hex');

        crypted += cipher.final('hex');
        grunt.file.write(file.dest, crypted);
        grunt.log.writeln('Encrypting ' + file.src[0].cyan + ' -> ' + file.dest.cyan);
        cb();
      },
      function(result) {
        done(result);
      });
  });

  grunt.registerTask('build-datetime', function() {
    grunt.file.write('tmp/build', new Date().valueOf());
  });

  grunt.registerTask('stage', function() {
    grunt.file.write('tmp/stage', (function(NODE_ENV) {
      switch (NODE_ENV) {
        case 'production':
          return '';
        case '':
        case undefined:
        case null:
          return 'development';
        default:
          return NODE_ENV;
      }
    })(process.env.NODE_ENV));
  });

  grunt.registerMultiTask('decrypt', function() {
    var options = this.options({
      "action": grunt.cli.options.crypt || "encrypt",
      "keyfile": grunt.cli.options.keyfile
    });

    if (!process.env.KEY && !grunt.file.exists(options.keyfile)) {
      grunt.log.writeln("Key file " + options.keyfile + " does not exist.");
      return;
    }
    var done = this.async();

    var key = process.env.KEY || grunt.file.read(options.keyfile);
    async.each(this.files, function(file, cb) {
        var crypted = grunt.file.read(file.src[0]);
        var cipher = crypto.createDecipher('aes-256-cbc', key);

        var text = cipher.update(crypted, 'hex', 'utf8');
        text += cipher.final('utf8');
        grunt.file.write(file.dest, text);
        grunt.log.writeln('Encrypting ' + file.src[0].cyan + ' -> ' + file.dest.cyan);
        cb();
      },
      function(result) {
        done(result);
      });
  });

  grunt.registerTask('build', ['bump:build:bump-only', 'build-datetime', 'stage', 'encrypt', 'decrypt', 'bower-install', 'bower', 'jst', 'nodeunit', 'jshint', 'jsbeautifier', 'copy', 'requirejs', 'less', 'apidoc']);
  grunt.registerTask('server', ['env', 'express:server']);
  grunt.registerTask('default', 'build');
  grunt.registerTask('heroku:staging', 'default');
  grunt.loadNpmTasks('grunt-env');
  grunt.loadNpmTasks('grunt-jsbeautifier');
  grunt.loadNpmTasks('grunt-apidoc');
  grunt.loadNpmTasks('grunt-contrib-jst');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-nodeunit');
  grunt.loadNpmTasks('grunt-bower-requirejs');
  grunt.loadNpmTasks('grunt-contrib-requirejs');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-express');
  grunt.loadNpmTasks('grunt-bump');
};
