  var uuid = require('node-uuid'),
    libs = require('../libs'),
    emailer = libs.emailer,
    models = require('../models'),
    Registration = require('../models').registration;

  module.exports = [{
    /**
     * @api {post} /registration Register an email address
     * @apiName Register
     * @apiGroup Registration
     *
     * @apiParam {String} emailAddress Registration Email Address.
     *
     * @apiSuccess {String} key Registration Key for creating a user;
     *
     * @apiSuccessExample Success-Response:
     *     HTTP/1.1 200 OK
     *     {
     *       "key": "dGVzdA=="
     *     }
     *
     * @apiError EmailAddressNotValid The email address entered is not valid.
     *
     * @apiErrorExample Error-Response:
     *     HTTP/1.1 404 Not Found
     *     {
     *       "error": "EmailAddressNotValid",
     *     }
     */


    verb: 'post',
    callback: function(request, callback) {
      var data = {
        emailAddress: request.body.emailAddress,
        secret: new Buffer(uuid.parse(uuid.v4())),
        key: new Buffer(uuid.parse(uuid.v4()))
      };
      Registration.create(data).success(function(registration) {
        emailer.queue('confirmation', {
          emailAddress: data.emailAddress,
          secret: data.secret.toString('base64')
        }, function(error, response) {
          callback(error ? 400 : undefined, error ? error : {
            key: data.key.toString('base64')
          });
        });
      }).error(function(error) {
        if (error.emailAddress) {
          callback(400, {
            error: error
          });
          return;
        } else if (error) {
          callback(500, error);
          return;
        }
      });
    }
  }];
