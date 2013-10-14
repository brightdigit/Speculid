var proxyquire = require('proxyquire').noCallThru();

function mockModel(data) {
  for (var key in data) {
    this[key] = data[key];
  }
}

mockModel.prototype.save = function() {
  if (this.emailAddress === "example@invalid.com") {
    this._error = "account already exists";
  }

  return this;
};

mockModel.prototype.success = function(cb) {
  if (!this._error) {
    cb(this);
  }

  return this;
};

mockModel.prototype.error = function(cb) {
  if (this._error) {
    cb(this._error);
  }

  return this;
};

var controller = require('../../app/controllers/_controller.js');
var registration = proxyquire('../../app/controllers/registration.js', {
  'node-uuid': {
    v4: function() {
      return 'test';
    },
    parse: function(value) {
      return value;
    }
  },
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
  },
  '../models': {
    registration: {
      build: function(data) {
        return new mockModel(data);
      }
    }
  }
});

exports.registration = {
  testValid: function(test) {
    var request = {
      body: {
        emailAddress: 'example@valid.com'
      }
    };
    controller.find(registration, {
      verb: 'post'
    })(request, function(status, result) {
      test.ok(result.key === (new Buffer('test')).toString('base64'));
      test.done();
    });
  },
  testInvalid: function(test) {
    var request = {
      body: {
        emailAddress: 'example@invalid.com'
      }
    };
    controller.find(registration, {
      verb: 'post'
    })(request, function(status, result) {
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
    controller.find(registration, {
      verb: 'post'
    })(request, function(status, result) {
      test.ok(status === 400);
      test.ok(result.error === 'email failure');
      test.done();
    });
  }
};
