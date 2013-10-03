var proxyquire = require('proxyquire');

function mockModel (data) {
  for (var key in data) {
    this[key] = data[key];
  }
}

mockModel.prototype.save = function (cb) {
  if (this.emailAddress === "already@exists.com") {
    cb("account already exists");
    return;
  }
  cb(undefined, this);
};

var account = proxyquire('../../app/controllers/Account.js', {
  'node-uuid' : {
    v4 : function () {
      return 'test';
    }
  },
  './emailer.js' : {
    send : function (name, data, cb) {

    }
  },
  '../models/account.js' : mockModel
});

exports.Register = {
  testValid: function(test) {
    var request = {
      body: {
        emailAddress: 'example@valid.com'
      }
    };
    account.Register(request, function (status, result) {
      test.ok(result.key === 'test');
      test.done();
    });
  },
  testAlreadyExists: function(test) {
    var request = {
      body: {
        emailAddress: "already@exists.com"
      }
    };
    account.Register(request, function (status, result) {
      test.ok(status === 400);
      test.ok(result === "account already exists");
      test.done();
    });
  },
  testInvalidEmailAddress: function(test) {
    test.ok(false, "this assertion should fail");
    test.done();
  },
  testPropertyExists: function(test) {
    var request = {
      body: {
        emailAddress: 'example@valid.com'
      }
    };
    account.Register(request, function (status, result) {
      test.ok(status === 400);
      test.ok(result.reason === 'test');
      test.done();
    });
  },
};

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