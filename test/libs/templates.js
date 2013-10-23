var proxyquire = require('proxyquire').noCallThru();
var templates = proxyquire('../../server/libs/templates.js', {
  './lsr': function(path, callback, iterator, keyIterator) {
    if (path === 'unknownDirectory') {
      callback({
        errno: 34,
        code: 'ENOENT',
        path: 'test2'
      }, undefined);
      return;
    }
    iterator('test.json', function(error, result) {

      callback(error, {
        'test': result
      });
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
        iterator(item, function() {});
      });
      callback();
    },
    reduce: function(arr, memo, iterator, callback) {

      arr.forEach(function(item) {
        iterator(memo, item, function(error, newmemo) {});
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

exports.unknownDirectory = function(test) {
  templates('unknownDirectory', newRequire)('test', {
    x: true,
    y: true
  }, function(error, content) {
    test.deepEqual(error, {
      errno: 34,
      code: 'ENOENT',
      path: 'test2'
    });
    test.done();
  });
};

exports.unknownTemplate = function(test) {
  templates('test', newRequire)('unknownTemplate', {
    x: true,
    y: true
  }, function(error, content) {
    test.strictEqual(content, undefined);
    test.done();
  });
};
