var registration = require("../../libs/controller")("registration", {
  '../libs': {
    emailer: {
      queue: function(name, data, cb) {
        if (data.emailAddress === 'example@emailFailure.com') {
          cb({
            error: 'email failure'
          });
          return;
        }
        cb(undefined, {
          key: 'test'
        });
      }
    }
  }
});

exports.registration = {
  setUp: registration.sync(),
  testValid: function(test) {
    var request = {
      body: {
        emailAddress: 'example@valid.com'
      }
    };
    registration.find({
      verb: 'post'
    })(request, function(status, result) {
      test.ok(status === 200 || status === undefined);
      test.ok(result.key);
      test.done();
    });
  },
  testInvalid: function(test) {
    var request = {
      body: {
        emailAddress: 'example.com'
      }
    };
    registration.find({
      verb: 'post'
    })(request, function(status, result) {
      test.ok(status === 400);
      test.ok( !! result.error);
      test.done();
    });
  },
  testEmailFailure: function(test) {
    var request = {
      body: {
        emailAddress: 'example@emailFailure.com'
      }
    };
    registration.find({
      verb: 'post'
    })(request, function(status, result) {
      test.ok(status === 400);
      test.ok( !! result.error);
      test.done();
    });
  }
};
