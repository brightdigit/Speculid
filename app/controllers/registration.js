var uuid = require('node-uuid'),
  libs = require('../libs'),
  emailer = libs.emailer,
  models = require('../models'),
  registration = require('../models').registration;

module.exports = {
  Register: function(request, callback) {
    var secret, key;
    var emailAddress = request.body.emailAddress;

    var data = {
      emailAddress: request.body.emailAddress,
      secret: new Buffer(uuid.parse(uuid.v4())),
      key: new Buffer(uuid.parse(uuid.v4()))
    };
    var ar = registration.build(data);

    ar.save().success(function(ar) {
      emailer.queue('confirmation', {
        emailAddress: data.emailAddress,
        secret: data.secret.toString('base64')
      }, function(error, response) {
        callback(error, error ? response : {
          key: data.key.toString('base64')
        });
      });
    }).error(function(error) {
      if (error) {
        callback(400, error);
        return;
      }
    });
  },
  Confirm: function(request) {

  },
  Login: function(request) {

  }
};
