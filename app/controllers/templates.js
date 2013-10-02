var lsr = require('./lsr');
var _ = require('underscore');
var path = require('path');
var async = require('async');

module.exports = function() {
  var _cached = {};

  function templateSet(dirpath, req) {
    var _templates;
    var require = req || require;

    function template(filepath, cb) {
      var result = {};
      var ext = path.extname(filepath);
      var name = path.basename(filepath, ext);
      try {
        var json = require(filepath);
      } catch (e) {
        cb();
      }
      console.log(json);
      Object.keys(json).forEach(function(key) {
        result[key] = _.template(json[key]);
      });
      cb(undefined, {
        name: result
      });
    }

    function parsed(name, cb) {
      function reduce(memo, item, cb) {
        async.each(Object.keys(item),
          function(key, cb) {
            memo[key] = item[key];
            cb();
          },
          function(error) {
            cb(error, memo);
          });
      }

      function _parsed(name, cb, error, results) {
        async.reduce(results, {}, reduce,
          function(error, result) {
            _templates = result;
            cb(undefined, _templates[name]);
          }
        );
      }

      _parsed.bind(undefined, name, cb);
    }

    return function(name, cb) {
      if (!_templates) {
        lsr(dirpath, parsed(name, cb), template);
      } else {
        cb(undefined, _templates[name]);
      }
    };
  };

  return function(dirpath, req) {
    dirpath = path.resolve(dirpath);
    req = req || require;
    if (!_cached[dirpath]) {
      _cached[dirpath] = templateSet(dirpath, req);
    }
    return _cached[dirpath];
  };
}();