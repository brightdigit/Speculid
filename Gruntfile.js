module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    jshint: {
      all: ['Gruntfile.js', 'app/**/*.js', 'test/**/*.js', 'app/**/*.json', 'test/**/*.json']
    },
    nodeunit: {
      all: ['test/**/*.js']
    },
    jsbeautifier: {
      "default": {
        src: ['Gruntfile.js', "app/**/*.js", "test/**/*.js", "app/**/*.json", "test/**/*.json"],
        options: {
          js: {
            indent_size: 2
          }
        }
      },
      "git-pre-commit": {
        src: ['Gruntfile.js', "app/**/*.js", "test/**/*.js", "app/**/*.json", "test/**/*.json"],
        options: {
          mode: "VERIFY_ONLY",
          js: {
            indent_size: 2
          }
        }
      }
    }
  });

  // A very basic default task.
  grunt.registerTask('sample', 'Log some stuff.', function() {
    grunt.log.write('Logging some stuff...').ok();
  });

  grunt.registerTask('default', ['sample', 'nodeunit', 'jshint', 'jsbeautifier']);

  grunt.loadNpmTasks('grunt-jsbeautifier');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-nodeunit');
};
