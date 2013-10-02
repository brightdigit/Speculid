var proxyquire = require('proxyquire').noCallThru();
var templates = proxyquire('../../app/controllers/templates.js', {
  './lsr': function(path, callback, iterator) {
    console.log('test');
    var results = ['a','b','c'].map(function (item) {
      iterator(item, function (error, result) {
        return result;
      })
    });
    callback(undefined, results);
  },
  _: {
    template: function(str) {
      return function(data) {

      };
    }
  },
  path: {
    extname: function(file) {

    },
    basename: function(file, ext) {

    },
    resolve : function (file) {
      return file;
    }
  },
  async: {
    each: function(arr, iterator, callback) {

    },
    reduce : function (arr, memo, iterator, callback) {
      callback(undefined, {
        'test' : true
      });
    }
  }
});

function newRequire (filePath) {
  return {
    "to" : "test"
  };
}

exports.load = function (test) {
  templates('test', newRequire)('test', function (error, template) {
    test.ok(template);
    test.done();
  });
};