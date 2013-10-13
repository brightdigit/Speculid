  var uuid = require('node-uuid'),
    libs = require('../libs'),
    emailer = libs.emailer,
    async = require('async'),
    models = require('../models'),
    registration = models.registration,
    user = models.user;

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
      /*
      request.body.key
      request.body.secret
      request.body.emailAddress
      request.body.name
      request.body.password
      */
      function findRegistration (cb) {

        registration.find({ 
          where : "emailAddress = ? and key = ? and secret = ? and registeredAt > DATE_SUB(NOW(), INTERVAL 5 MINUTE)", 
          order : "registeredAt DESC"}
        ).success(function (registration) {
          cb(undefined, registration);
        });
      }

      function findUser (cb) {
        // returns list of similar username available or undefined for available name or empty for no similar name
      }

      async.parallel([findRegistration, findUser], function (err, results) {
        callback(err, results);
      });
      /*
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
          callback(error ? 400 : undefined, error ? error : {
            key: data.key.toString('base64')
          });
        });
      }).error(function(error) {
        if (error) {
          callback(400, error);
          return;
        }
      });
  */
    }
  }];
