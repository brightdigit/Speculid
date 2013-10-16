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
var registration = proxyquire('../../app/controllers/user.js', {
});

exports.user = {
  testValid: function(test) {
    controller.find(registration, {"verb" : "post"})(request,
      function (status, result) {
        test.ok(false);
        test.done();
    });
  },
  testInvalidName : function (test) {
    controller.find(registration, {"verb" : "post"})(request,
      function (status, result) {
        test.ok(false);
        test.done();
    });
  }
};
