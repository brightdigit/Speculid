var async = require('async'),
  fs = require('fs'),
  path = require('path');

module.exports = function() {
  var lsr = function(root, callback, iterator, keyIterator) {
    this.root = root;
    this.callback = callback;
    this.iterator = iterator || this.iterator;
    this.keyIterator = keyIterator;
    this.memo = keyIterator ? {} : [];
  };

  lsr.readdir = function(path, callback, iterator, keyIterator) {
    return (new lsr(path, callback, iterator, keyIterator)).begin();
  };

  lsr.prototype = {
    begin: function() {
      this.readdir(this.root, this.callback.bind(this));
    },

    iterator: function(item, cb) {
      cb(undefined, item);
    },

    readdir: function(path, cb, memo) {
      memo = memo || {};
      fs.readdir(path, this.statfiles.bind(this, path, cb, memo));
    },

    statfiles: function(parent, cb, memo, error, files) {

      async.reduce(files, memo, this.statfile.bind(this, parent), cb);
    },

    statfile: function(parent, memo, file, cb) {
      var filepath = path.join(parent, file);
      fs.stat(filepath, this.parsefiledir.bind(this, filepath, cb, memo));
    },

    reduceIterator: function(filepath, cb, memo) {

      async.map([this.keyIterator.bind(this), this.iterator.bind(this)],
        function(item, cb) {


          item(filepath, cb);
        },
        function(error, results) {
          memo[results[0]] = results[1];
          cb(error, memo);
        }
      );
    },

    parsefiledir: function(filepath, cb, memo, error, stats) {
      if (stats.isFile()) {
        if (this.keyIterator) {
          this.reduceIterator(filepath, cb, memo);
        } else {
          this.iterator(filepath, cb);
        }
      } else if (stats.isDirectory()) {
        this.readdir(filepath, cb, memo);
      } else {
        cb(undefined);
      }
    }
  };

  return lsr.readdir;
}();