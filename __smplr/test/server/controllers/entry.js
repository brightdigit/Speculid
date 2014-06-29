var crypto = require('crypto');
var entry = require("../../libs/controller")("entry");

var Session = entry.models.session,
  App = entry.models.app;

var sessionKey = crypto.randomBytes(48),
  ipAddress = '127.0.0.1',
  app = null;

exports.session = {
  setUp: function(callback) {
    entry._sync(function(error) {
      if (error) {
        callback(error);
        return;
      }
      var q = entry.querychainer();
      q.add(Session.create({
        key: sessionKey,
        clientIpAddress: ipAddress
      }));
      q.add(App.createByName('test'));
      q.run().success(function(results) {
        results[0].setApp(results[1]).success(function() {
          app = results[1];
          callback();
        });
      });
    });
  },
  testValid: function(test) {
    var request = {
      body: {
        apiKey: app.key,
        sessionKey: sessionKey,
        item: 'example'
      },
      headers: {
        'user-agent': 'user agent 1.0'
      },
      connection: {
        remoteAddress: '127.0.0.1'
      }
    };
    entry.find({
      "verb": "post"
    })(request,
      function(status, result) {
        test.ok(status === 200 || status === undefined);
        test.done();
      });
  },
  testInvalidAppKey: function(test) {
    var request = {
      body: {
        apiKey: 'badKey',
        sessionKey: sessionKey,
        item: 'example'
      },
      headers: {
        'user-agent': 'user agent 1.0'
      },
      connection: {
        remoteAddress: '127.0.0.1'
      }
    };
    entry.find({
      "verb": "post"
    })(request,
      function(status, result) {
        test.ok(status === 401);
        test.done();
      });
  },
  testInvalidSessionKey: function(test) {
    var request = {
      body: {
        apiKey: app.key,
        sessionKey: 'badKey',
        item: 'example'
      },
      headers: {
        'user-agent': 'user agent 1.0'
      },
      connection: {
        remoteAddress: '127.0.0.1'
      }
    };
    entry.find({
      "verb": "post"
    })(request,
      function(status, result) {
        test.ok(status === 401);
        test.done();
      });
  },
  testInvalidEntry: function(test) {
    var request = {
      body: {
        apiKey: app.key,
        sessionKey: sessionKey,
        item: '#!@#!@'
      },
      headers: {
        'user-agent': 'user agent 1.0'
      },
      connection: {
        remoteAddress: '127.0.0.1'
      }
    };
    entry.find({
      "verb": "post"
    })(request,
      function(status, result) {
        test.ok(status === 400);
        test.done();
      });
  }
};
