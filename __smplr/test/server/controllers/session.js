var session = require("../../libs/controller")("session");

var User = session.models.user,
  App = session.models.app;

exports.session = {
  setUp: function(callback) {
    session._sync(function(error) {
      if (error) {
        callback(error);
        return;
      }
      var q = session.querychainer();
      q.add(User.newLogin({
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
    session.find(session, {
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
    session.find(session, {
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
    session.find(session, {
      "verb": "post"
    })(request,
      function(status, result) {
        test.equals(status, 400);
        test.ok( !! result.error);
        test.done();
      });
  }
};
