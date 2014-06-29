var libs = require('../libs'),
  async = require('async'),
  QueryChainer = require("sequelize").Utils.QueryChainer,
  models = require('../models');

var emailer = libs.emailer,
  logger = libs.logger;

var Registration = models.registration,
  User = models.user;

module.exports = [{
  /**
   * @api {post} /user Confirm and create a new user.
   * @apiName Confirm
   * @apiGroup User
   *
   * @apiParam {String} key Registration Key.
   * @apiParam {String} secret Registration Secret sent through email.
   * @apiParam {String} emailAddress Registration Email Address.
   * @apiParam {String} name Username.
   * @apiParam {String} password Password.
   *
   * @apiSuccessExample Success-Response:
   *     HTTP/1.1 200 OK
   *
   * @apiError RegistrationNotFound The registration information given is not found.
   *
   * @apiErrorExample Error-Response:
   *     HTTP/1.1 404 Not Found
   *     {
   *       "error": "RegistrationNotFound"
   *     }
   *
   * @apiError UsernameAlreadyInUse The user name requested is already in use.
   *
   * @apiErrorExample Error-Response:
   *     HTTP/1.1 404 Not Found
   *     {
   *       "error": "UsernameAlreadyInUse"
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

    function findRegistration(cb) {
      Registration.find({
        where: {
          emailAddress: request.body.emailAddress,
          key: new Buffer(request.body.key, 'base64'),
          secret: new Buffer(request.body.secret, 'base64'),
          userId: null,
          registeredAt: {
            gt: new Date(new Date() - 5 * 60 * 1000)
          }
        },
        order: "registeredAt DESC"
      }).success(function(registration) {
        cb(undefined, registration);
      }).error(function(error) {
        cb(error, undefined);
      });
    }

    function findUser(cb) {
      User.find({
        where: {
          name: request.body.name
        }
      }).success(function(user) {
        cb(undefined, user);
      }).error(function(error) {
        cb(error);
      });
    }
    async.parallel({
      registration: findRegistration,
      user: findUser
    }, function(err, results) {
      if (results.registration && !results.user) {
        var user = User.newLogin({
          name: request.body.name,
          password: request.body.password,
          emailAddress: request.body.emailAddress
        }).success(function(user) {
          var chain = new QueryChainer();
          chain.add(user.setRegistration(results.registration));
          chain.add(results.registration.setUser(user));
          chain.run().success(function(results) {
            callback(201, {
              name: request.body.name
            }, {
              "Location": "/user/" + request.body.name
            });
          }).error(function(error) {
            logger.error(error);
            callback(500, {
              error: error
            });
          });
        }).error(function(error) {
          if (error.name) {
            callback(400, {
              error: error
            });
          } else {
            logger.error(error);
            callback(500, {
              error: error
            });
          }
        });
      } else {
        if (!results.registration) {
          callback(400, {
            "error": "Registration information invalid."
          });
        } else if (results.user) {
          callback(400, {
            "error": "Username is already being used."
          });
        }
      }
    });
  }
}];
