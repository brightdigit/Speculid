var Git = require('git-wrapper'),
  path = require('path'),
  async = require('async'),
  beautify = require('js-beautify').js_beautify,
  fs = require('fs');

var git = new Git ();

function beautifyFile (fileName, cb) {
  fs.exists(fileName, function (exists) {
    if (!exists) {
      cb();
      return;
    }
    fs.readFile(fileName, 'utf8', function (err, data) {
      if (err) {
          cb(err);
          return;
      }
      fs.writeFile(fileName, beautify(data, { indent_size: 2 }), function(pError){
            cb(pError);
      });
    });
  });
}

git.exec('ls-files', function (error, message) {
  async.each(message.split('\n'), beautifyFile, function (error) {
    console.log(error);
  });
});