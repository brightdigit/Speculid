var proxyquire = require('proxyquire').noCallThru();
var templates = proxyquire('../../app/controllers/templates.js', {
  './lsr': function(path, callback, iterator, keyIterator) {
    iterator(path, function(error, result) {
      callback(error, [result, {
        'test2': {
          x: 0
        }
      }]);
    });
  },
  'underscore': {
    template: function(str) {
      return function(data) {
        return data;
      };
    }
  },
  path: {
    '@noCallThru': false,
    resolve: function(file) {
      return file;
    }
  },
  async: {
    each: function(arr, iterator, callback) {
      arr.forEach(function(item) {
        iterator(item, function() {})
      });
      callback();
    },
    reduce: function(arr, memo, iterator, callback) {

      arr.forEach(function(item) {
        iterator(memo, item, function(error, newmemo) {})
      });

      callback(undefined, memo);
    }
  }
});

function newRequire(filePath) {
  return {
    "to": "test",
    "from": "test"
  };
}

exports.load = function(test) {
  templates('test', newRequire)('test', {
    x: true,
    y: true
  }, function(error, content) {
    test.ok(content.to.x);
    test.ok(content.from.y);
    test.done();
  });
};