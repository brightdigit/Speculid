var async = require('async'),
  models = require('../models');

var User = models.user,
  App = models.app;

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
    // find user
    // find app
    // find or create device

    function findUser(requestBody) {
      function _(requestBody, cb) {

      }

      return _.bind(undefined, requestBody);
    }

    function findApp(requestBody) {
      function _(requestBody, cb) {

      }

      return _.bind(undefined, requestBody);
    }

    function findDevice(request) {
      function _(request, cb) {

      }

      return _.bind(undefined, requestBody);
    }

    function beginSession(device, app, user, request, callback) {
      callback(500);
    }

    async.parellel({
      user: findUser(request.body),
      app: findApp(request.body),
      device: findDevice(request)
    }, function(error, result) {
      if (!user) {
        callback(401, {
          error: "Unknown username or password."
        });
      } else if (!app) {
        callback(400, {
          error: "Unknown application key."
        });
      } else {
        beginSession(device, app, user, request, callback);
      }
    });
  }
}];
