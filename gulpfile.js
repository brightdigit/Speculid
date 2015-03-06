var gulp = require('gulp'),
    fs = require('fs'),
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
    nstatic = require('node-static'),
    yaml = require('js-yaml'),
    uglify = require('gulp-uglify')
    uglifycss = require('gulp-uglifycss')
    htmlmin = require('gulp-htmlmin'),
    htmlreplace = require('gulp-html-replace');

var getPackageJson = function () {
  return JSON.parse(fs.readFileSync('./package.json', 'utf8'));
};
var httpServer;
gulp.task('default', ['build', 'bump']);
gulp.task('build', ['clean', 'browserify', 'sass', 'htmlminify', 'copy']);

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

function get (value) {
  return (typeof(value) === 'string') ? value : (Object.keys(value)[0]);
}

gulp.task('yaml', ['clean'],   function (cb) {
  if (!fs.existsSync('./.tmp')) {
    fs.mkdirSync('./.tmp');
  }
  fs.readFile('./db/data.yaml', 'utf8', function (error, data) {
    var data = yaml.load(data);
    var result = {};
    result["os"] = data.os;
    result["devices"] = data.devices;
    result["display"] = data.display;
    result["assets"] = data.assets;
    result["badge"] = data.badge;
    var images = {pixels : {}, points : {}};
    var resolutions = {};

    function getSize (value, device) {
      if (Array.isArray(value)) {
        return [value[0] * resolutions[device], value[value.length-1] * resolutions[device]];
      } else {
        return value * resolutions[device];
      }
      
    }

    function getPoints (value, device) {
      if (Array.isArray(value)) {
        return [value[0], value[value.length-1]];
      } else {
        return value;
      }      
    }

    for (var resolution in data.resolutions) {
      for (var index = 0; index < data.resolutions[resolution].length; index++) {
        resolutions[data.resolutions[resolution][index]] = resolution;
      }
    }

    for (var name in data.images) {
      var value = data.images[name];
      var sizes, points;
      if (typeof(value) === 'object' && !Array.isArray(value)) {
        sizes = {};
        points = {};
        for (var type in data.types) {
          for (var index = 0; index < data.types[type].length; index++) {
            if (value[type]) {
              sizes[data.types[type][index]] = getSize(value[type],data.types[type][index]); 
              points[data.types[type][index]] = getPoints(value[type],data.types[type][index]); 
            }
          }
        }
        for (var index = 0; index < data.devices.length; index++) {
          var device = data.devices[index];
          if (value[device]) {
            sizes[device] = getSize(value[device],device); 
            points[device] = getPoints(value[device],device); 
          }
        }
      } else {

        sizes = data.devices.reduce(function (memo, device) {
          memo[get(device)] = getSize(value,get(device));
          return memo;
        }, {});
        points = data.devices.reduce(function (memo, device) {
          memo[get(device)] = getPoints(value,get(device));
          return memo;
        }, {});
      }
      if (sizes) {
        images.pixels[name] = sizes;
      }
      if (points) {
        images.points[name] = points;
      }
    }

    var types = data.types;

    result["images"] = images;
    result["resolutions"] = resolutions;
    fs.writeFileSync('./.tmp/data.json', JSON.stringify(result));
    cb();
  });
});

gulp.task('watch', ['default'], function () {
  gulp.watch('static/**/*', ['build']);
});

gulp.task('clean', function (cb) {
  async.each(['public', '.tmp', '.coverdata'], rimraf, cb);
});

gulp.task('copy', ['clean'], function () {
  return es.merge(
    gulp.src('static/fonts/**/*.*').pipe(gulp.dest('public/fonts')), 
    gulp.src('static/images/**/*.*').pipe(gulp.dest('public/images')),
    gulp.src('CNAME').pipe(gulp.dest('public')));
});

gulp.task('htmlminify', ['clean', 'bump'], function() {
  
  gulp.src('static/html/**/*.html')
    .pipe(htmlreplace({version: {
      src: getPackageJson().version
      //tpl: '<img src="%s" align="left" />'
    }}))
    .pipe(htmlmin({collapseWhitespace: true, removeComments: true, removeEmptyAttributes: true}))
    .pipe(gulp.dest('public'))
});

gulp.task('sass', ['clean'], function () {
  return gulp.src('static/scss/**/*.scss')
  .pipe(sass({includePaths: require('node-bourbon').includePaths}))
  .pipe(uglifycss())
  .pipe(gulp.dest('public/css'));
});

gulp.task('browserify', ['yaml'], function () {
  var browserified = transform(function(filename) {
    var b = browserify(filename);
    return b.bundle();
  });
  
  return gulp.src(['./static/js/main.js'])
    .pipe(browserified)
    //.pipe(uglify())
    .pipe(gulp.dest('./public/js'));
});

gulp.task('bump', ['clean'], function () {
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