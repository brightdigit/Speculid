var async = require('async'),
	fs = require('fs'),
  path = require('path');

module.exports = function (){
  var lsr = function (root, callback, iterator) {
    this.root = root;
    this.callback = callback;
    this.iterator = iterator ? iterator : this.iterator;
  };

  lsr.readdir = function (path, callback, iterator) {
    return (new lsr(path, callback, iterator)).begin();
  };

  lsr.prototype = {
    begin : function () {
      this.readdir(this.root, this.callback.bind(this));
    },

    iterator : function (item, cb) {
      cb(undefined, item);
    },

    readdir : function (path, cb) {
      fs.readdir(path, this.statfiles.bind(this, path, cb));
    },

    statfiles : function (parent, cb, error, files) {
      async.concat(files, this.statfile.bind(this, parent), cb);
    },

    statfile : function (parent, file, cb) {
      var filepath = path.join(parent, file);
      fs.stat(filepath, this.parsefiledir.bind(this, filepath, cb));
    },

    parsefiledir : function (filepath, cb, error, stats) {
      if (stats.isFile()) {
        this.iterator(filepath, cb);
      } else if (stats.isDirectory()) {
        this.readdir(filepath, cb);
      } else {
        cb(undefined);
      }
    }
  };

  return lsr.readdir;
}();