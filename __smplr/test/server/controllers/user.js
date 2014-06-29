var user = require("../../libs/controller")("user");

var User = user.models.user,
  Registration = user.models.registration;

function base64buffer(str) {
  return (new Buffer(str, 'base64'));
}

exports.user = {
  setUp: user.sync(function(error, cb) {
    var qc = user.querychainer();
    qc.add(Registration.create({
      emailAddress: 'example@valid.com',
      secret: base64buffer('secret'),
      key: base64buffer('key'),
      registeredAt: (new Date())
    }));
    qc.add(Registration.create({
      emailAddress: 'old@valid.com',
      secret: base64buffer('secret'),
      key: base64buffer('key'),
      registeredAt: (new Date(new Date() - 1000 * 60 * 6))
    }));
    qc.add(User.newLogin({
      emailAddress: 'new@valid.com',
      name: 'nameAlreadyInUse',
      password: 'test'
    }));
    qc.run().success(function() {
      cb();
    }).error(function(error) {
      console.log(error);
      //cb();
    });
  }),
  testValid: function(test) {
    var request = {
      body: {
        emailAddress: 'example@valid.com',
        secret: 'secret',
        key: 'key',
        name: 'example',
        password: 'test'
      }
    };
    user.find(user, {
      "verb": "post"
    })(request,
      function(status, result) {
        test.ok(status === 201);
        test.done();
      });
  },
  testNameAlreadyInUse: function(test) {
    var request = {
      body: {
        emailAddress: 'example@valid.com',
        secret: 'secret',
        key: 'key',
        name: 'nameAlreadyInUse',
        password: 'test'
      }
    };
    user.find(user, {
      "verb": "post"
    })(request,
      function(status, result) {
        test.equals(status, 400);
        test.ok( !! result.error);
        test.done();
      });
  },
  testNameDoesNotMatchRegex: function(test) {
    var request = {
      body: {
        emailAddress: 'example@valid.com',
        secret: 'secret',
        key: 'key',
        name: '',
        password: 'test'
      }
    };
    user.find(user, {
      "verb": "post"
    })(request,
      function(status, result) {

        test.ok(status === 400);
        test.ok( !! result.error.name);
        test.done();
      });
  },
  testRegistrationNotFound: function(test) {
    var request = {
      body: {
        emailAddress: 'registrationNotFound@valid.com',
        secret: 'secret',
        key: 'key',
        name: 'example',
        password: 'test'
      }
    };
    user.find(user, {
      "verb": "post"
    })(request,
      function(status, result) {
        test.equals(status, 400);
        test.ok( !! result.error);
        test.done();
      });
  },
  testRegistrationTooOld: function(test) {
    var request = {
      body: {
        emailAddress: 'old@valid.com',
        secret: 'secret',
        key: 'key',
        name: 'example',
        password: 'test'
      }
    };
    user.find(user, {
      "verb": "post"
    })(request,
      function(status, result) {
        test.doesNotThrow(function() {
          test.ok(status);
          test.strictEqual(status, 400);
          test.ok( !! result.error);
        });
        test.done();
      });
  }
};
