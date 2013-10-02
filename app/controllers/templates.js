var lsr = require('./lsr');
var _ = require('underscore');
var path = require('path');
var async = require('async');

module.exports = function() {
  var _cached = {};

  function _datatemplate (templates, data, cb) {
    async.reduce(Object.keys(templates), {}, 
      function (memo, templateKey, cb) {
        memo[templateKey] = templates[templateKey](data);
        cb(undefined, memo)
      },
      function (error, memo) {
        cb(undefined, memo);
      });
  }

  function datatemplate (templates) {
    return _datatemplate.bind(undefined, templates);
  }

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
      
      Object.keys(json).forEach(function(key) {
        
        
        result[key] = _.template(json[key]);

      });
      var retValue = {};
      retValue[name] = datatemplate(result);
      cb(undefined, retValue);
    }

    function parsed(name, cb) {
      function reduce(memo, item, cb) {
        
        async.each(Object.keys(item),
          function(key, cb) {
            
            memo[key] = item[key];
            cb();
          },
          function(error) {
            console.log(memo);
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

      return _parsed.bind(undefined, name, cb);
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