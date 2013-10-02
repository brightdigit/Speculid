var proxyquire = require('proxyquire').noCallThru();
var verify = {};
var lsr = proxyquire('../../app/controllers/lsr.js', {
  fs: {
    readdir: function(path, cb) {
      if (path == 'path') {
        cb(undefined, ['a', 'b', 'c']);
      } else if (path == 'path,b') {
        cb(undefined, ['ba', 'bc']);
      } else {
        cb('unknown path: ' + path)
      }
    },
    stat: function(filepath, cb) {
      cb(undefined, {
        isFile: function() {
          return filepath !== 'path,b';
        },
        isDirectory: function() {
          return filepath === 'path,b';
        }
      });
    }
  },
  async: {
    concat: function(arr, iterator, callback) {
      var result = [];
      this.reduce(arr, result, iterator, callback);
    },
    reduce: function(arr, memo, iterator, callback) {

      arr.forEach(function(item) {
        iterator(memo, item, function(error, newmemo) {})
      });
      callback(undefined, memo);
    },
    map: function(arr, iterator, callback) {
      var result = [];
      arr.forEach(function(item) {


        iterator(item, function(error, newmemo) {
          result.push(newmemo);
        });
      });

      callback(undefined, result);
    }
  },
  path: {
    join: function() {
      return Array.prototype.join.call(arguments);
    }
  }
});

exports.readir = function(test) {
  lsr('path',
    function(error, result) {
      test.ifError(error);
      console.log(result);
      test.done();
    },
    function(item, cb) {

      cb(undefined, item.length);
    },
    function(item, cb) {

      cb(undefined, item);
    });
};