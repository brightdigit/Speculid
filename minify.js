var Git = require('git-wrapper'),
  path = require('path');
  async = require('async'),
  minify = require('minify'),
  fs = require('fs');

var git = new Git ();

function minifyFile (fileName, cb) {
  minify.optimize(fileName, {
      callback: function(pData){
          cb();
          /*
          fs.writeFile(fileName, pData, function(pError){
            cb(pError);
              //Util.log(pError || 'minify: ' + 'file ' + lOut +' writed');
          });
*/
      }
  });
}

git.exec('ls-files', function (error, message) {
  async.each(message.split('\n'), minifyFile, function (error) {
    console.log(error);
  });
});