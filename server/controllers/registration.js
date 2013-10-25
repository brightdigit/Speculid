  var uuid = require('node-uuid'),
    libs = require('../libs'),
    emailer = libs.emailer,
    models = require('../models'),
    registration = require('../models').registration;

  module.exports = [{
    /**
     * @api {post} /registration Register an email address
     * @apiVersion 1.0.0
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
     *       "key": ""
     *     }
     *
     * @apiError UserNotFound The id of the User was not found.
     *
     * @apiErrorExample Error-Response:
     *     HTTP/1.1 404 Not Found
     *     {
     *       "error": "UserNotFound"
     *     }
     */


    verb: 'post',
    callback: function(request, callback) {
      var secret, key;
      var emailAddress = request.body.emailAddress;
      console.log(request.body);
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
