var lsr = require('./lsr');
var _ = require('underscore');
var path = require('path');
var async = require('async');

module.exports = function() {
  var _cached = {};

  function _datatemplate(templates, data, cb) {
    async.reduce(Object.keys(templates), {},
      function(memo, templateKey, cb) {
        memo[templateKey] = templates[templateKey](data);
        cb(undefined, memo)
      },
      function(error, memo) {

        cb(undefined, memo);
      });
  }

  function datatemplate(templates) {
    return _datatemplate.bind(undefined, templates);
  }

  function templateSet(dirpath, req) {
    var _templates;
    var require = req || require;

    function parsed(name, data, cb) {

      function _parsed(name, data, cb, error, results) {
        if (error) {
          cb(error);
          return;
        }

        _templates = results;

        if (_templates[name]) {
          _templates[name](data, cb);
          return;
        }

        cb();
      }
      return _parsed.bind(undefined, name, data, cb);
    }

    function templateData(filepath, cb) {
      var data, templates = {};
      try {
        data = require(filepath);
      } catch (e) {
        cb();
      }
      Object.keys(data).forEach(function(name) {
        templates[name] = _.template(data[name]);
      });
      cb(undefined, datatemplate(templates));
    }

    function templateName(filepath, cb) {

      cb(undefined, path.basename(filepath, '.json'));
    }

    return function(name, data, cb) {

      if (!_templates) {
        lsr(dirpath, parsed(name, data, cb), templateData, templateName);
      } else if (_templates[name]) {
        _templates[name](data, cb);
      } else {
        cb();
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