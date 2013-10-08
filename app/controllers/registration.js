var uuid = require('node-uuid'),
  emailer = require('./emailer.js'),
  sequelize = require('./data.js'),
  account_request = sequelize.import(__dirname + '/../models/request.js');

module.exports = {
  Register: function(request, callback) {
    var secret, key;
    var emailAddress = request.body.emailAddress;

    var data = {
      emailAddress: request.body.emailAddress,
      secret: new Buffer(uuid.parse(uuid.v4())),
      key: new Buffer(uuid.parse(uuid.v4()))
    };
    var ar = account_request.build(data);

    ar.save().success(function(ar) {
      emailer.queue('confirmation', {
        emailAddress: data.emailAddress,
        secret: data.secret
      }, function(error, response) {
        callback(error, error ? response : {
          key: data.key
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
