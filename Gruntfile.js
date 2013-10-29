module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    jshint: {
      all: ['Gruntfile.js', 'server/**/*.js', 'test/**/*.js', 'server/**/*.json', 'test/**/*.json']
    },
    nodeunit: {
      all: ['test/server/**/*.js']
    },
    apidoc: {
      tgio: {
        src: "server/",
        dest: "client/www/apidoc/"
      }
    },
    bower: {
      target: {
        rjsConfig: 'client/www/js/config.js'
      }
    },
    requirejs: {
      compile: {
        options: {
          baseUrl: "client/www/js",
          mainConfigFile: 'client/www/js/config.js',
          out: 'client/www/js/optimized.js',
          name: 'tgio'
        }
      }
    },
    jsbeautifier: {
      "default": {
        src: ['Gruntfile.js', "server/**/*.js", "test/**/*.js", "server/**/*.json", "test/**/*.json"],
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
        src: ['Gruntfile.js', "server/**/*.js", "test/**/*.js", "server/**/*.json", "test/**/*.json"],
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
    }
  });

  // A very basic default task.
  grunt.registerTask('sample', 'Log some stuff.', function() {
    grunt.log.write('Logging some stuff...').ok();
  });

  grunt.registerTask('default', ['nodeunit', 'jshint', 'jsbeautifier', 'apidoc']);

  grunt.loadNpmTasks('grunt-jsbeautifier');
  grunt.loadNpmTasks('grunt-apidoc');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-nodeunit');
  grunt.loadNpmTasks('grunt-bower-requirejs');
  grunt.loadNpmTasks('grunt-contrib-requirejs');
};
