var proxyquire = require('proxyquire').noCallThru();
var controller = proxyquire('../../app/controllers/controller.js', {});

exports.constructor = function (test) {
  test.ok(false);
  test.done();
};