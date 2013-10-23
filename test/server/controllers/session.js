var proxyquire = require('proxyquire').noCallThru();

var Sequelize = require("sequelize");
var sequelize = require("../../libs/sequelize.js");

var controller = require('../../../server/controllers/_controller.js');
var models = proxyquire('../../../server/models', {
  "../libs": {
    "sequelize": sequelize,
    "@noCallThru": false
  }
});
var session = proxyquire("../../../server/controllers/session", {
  "../models": models
});

var QC = Sequelize.Utils.QueryChainer;
var User = models.user,
  App = models.app;

exports.session = {
  setUp: function(callback) {
    sequelize.sync({
      force: true
    }).success(function() {
      var q = new QC();
      q.add(User.create({
        name: "example",
        password: "test",
        emailAddress: "test@gmail.com"
      }));
      q.add(App.create({
        name: "test",
        key: "apiKey"
      }));
      q.run().success(function() {
        callback();
      }).error(function(error) {
        console.log(error);
      });
    });
  },
  testValid: function(test) {
    var request = {
      body: {
        apiKey: 'apiKey',
        name: 'example',
        password: 'test'
      },
      headers: {
        'user-agent': 'user agent 1.0'
      },
      connection: {
        remoteAddress: '127.0.0.1'
      }
    };
    controller.find(session, {
      "verb": "post"
    })(request,
      function(status, result) {
        test.ok(status === 200 || status === undefined);
        test.done();
      });
  },
  testInvalidLogin: function(test) {
    var request = {
      body: {
        apiKey: 'apiKey',
        name: 'exampl',
        password: 'test'
      },
      headers: {
        'user-agent': 'user agent 1.0'
      }
    };
    controller.find(session, {
      "verb": "post"
    })(request,
      function(status, result) {
        test.equals(status, 401);
        test.ok( !! result.error);
        test.done();
      });
  },
  testInvalidApp: function(test) {
    var request = {
      body: {
        apiKey: 'key',
        name: 'example',
        password: 'test'
      },
      headers: {
        'user-agent': 'user agent 1.0'
      }
    };
    controller.find(session, {
      "verb": "post"
    })(request,
      function(status, result) {
        test.equals(status, 400);
        test.ok( !! result.error);
        test.done();
      });
  }
};
