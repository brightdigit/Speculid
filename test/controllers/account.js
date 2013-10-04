var proxyquire = require('proxyquire').noCallThru();

function mockModel(data) {
  for (var key in data) {
    this[key] = data[key];
  }
}

mockModel.prototype.save = function(cb) {
  if (this.emailAddress === "example@invalid.com") {
    cb("account already exists");
    return;
  }
  cb(undefined, this);
};

var account = proxyquire('../../app/controllers/Account.js', {
  'node-uuid': {
    v4: function() {
      return 'test';
    }
  },
  './emailer.js': {
    send: function(name, data, cb) {
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
  },
  '../models/account.js': mockModel
});

exports.Register = {
  testValid: function(test) {
    var request = {
      body: {
        emailAddress: 'example@valid.com'
      }
    };
    account.Register(request, function(status, result) {
      test.ok(result.key === 'test');
      test.done();
    });
  },
  testInvalid: function(test) {
    var request = {
      body: {
        emailAddress: 'example@invalid.com'
      }
    };
    account.Register(request, function(status, result) {
      test.ok(status === 400);
      test.ok(result === "account already exists");
      test.done();
    });
  },
  testEmailFailure: function(test) {
    var request = {
      body: {
        emailAddress: 'example@emailFailure.com'
      }
    };
    account.Register(request, function(status, result) {
      test.ok(status === 400);
      test.ok(result.error === 'email failure');
      test.done();
    });
  }
};

/*
exports.Confirm = {
  test: function(test) {
    test.ok(false, "test failed.");
    test.done();
  }
};


exports.Login = {
  test: function(test) {
    test.ok(false, "test failed.");
    test.done();
  }
};

exports.testSomethingElse = function(test) {
  test.ok(false, "this assertion should fail");
  test.done();
};
*/