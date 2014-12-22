var gulp = require('gulp'),
    bump = require('gulp-bump'),
    jshint = require('gulp-jshint'),
    beautify = require('gulp-beautify'),
    sass = require('gulp-sass'),
    es = require('event-stream'),
    async = require('async'),
    rimraf = require('rimraf'),
    rename = require('gulp-rename')
    browserify = require('browserify');
    transform = require('vinyl-transform'),
    nstatic = require('node-static');

var httpServer;
gulp.task('default', ['build', 'bump']);
gulp.task('build', ['clean', 'browserify', 'sass', 'copy']);

gulp.task('serve', ['default'], function () {
  function startServer () {
    var fileServer = new nstatic.Server('./public');
    httpServer = require('http').createServer(function (request, response) {
      request.addListener('end', function () {
          fileServer.serve(request, response);
      }).resume();
    });
    httpServer.listen(8080);
  }
  if (httpServer) {
    httpServer.close(startServer)
  } else {
    startServer();
  }
});

gulp.task('watch', ['default'], function () {
  gulp.watch('static/**/*', ['build']);
});

gulp.task('clean', function (cb) {
  async.each(['public', '.tmp', '.coverdata'], rimraf, cb);
});

gulp.task('copy', ['clean'], function () {
  return es.merge(
  gulp.src('static/html/*.html').pipe(gulp.dest('public')), gulp.src('static/fonts/**/*.*').pipe(gulp.dest('public/fonts')), gulp.src('static/images/**/*.*').pipe(gulp.dest('public/images')));
});

gulp.task('sass', ['clean'], function () {
  return gulp.src('static/scss/**/*.scss').pipe(sass({includePaths: require('node-bourbon').includePaths})).pipe(gulp.dest('public/css'));
});

gulp.task('browserify', function () {
  var browserified = transform(function(filename) {
    var b = browserify(filename);
    return b.bundle();
  });
  
  return gulp.src(['./static/js/main.js'])
    .pipe(browserified)
    //.pipe(uglify())
    .pipe(gulp.dest('./public/js'));
});

gulp.task('bump', function () {
  gulp.src(['./package.json']).pipe(bump({
    type: 'patch'
  })).pipe(gulp.dest('./'));
});

gulp.task('lint', ['beautify'], function () {
  return gulp.src(['./gulpfile.js', 'static/js/**/*.js']).pipe(jshint()).pipe(jshint.reporter('default'));
});

gulp.task('beautify', ['lint'], function () {
  gulp.src(['./gulpfile.js', 'static/js/**/*.js'], {
    base: '.'
  }).pipe(beautify({
    indentSize: 2,
    preserveNewlines: true
  })).pipe(gulp.dest('.'));
});