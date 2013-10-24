var async = require('async'),
  crypto = require('crypto'),
  models = require('../models'),
  QueryChainer = require('Sequelize').Utils.QueryChainer;

var User = models.user,
  App = models.app,
  Device = models.device,
  Session = models.session;

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
        User.findByLogin(requestBody.name, requestBody.password, cb.bind(undefined, undefined));
      }

      return _.bind(undefined, requestBody);
    }

    function findApp(requestBody) {
      function _(requestBody, cb) {
        App.findByKey(requestBody.apiKey).success(cb.bind(undefined, undefined));
      }

      return _.bind(undefined, requestBody);
    }

    function findDevice(request) {
      function _(request, cb) {
        Device.findByKey(request.body.deviceKey, request.headers['user-agent'], cb.bind(undefined, undefined));
      }

      return _.bind(undefined, request);
    }

    function beginSession(device, app, user, request, callback) {
      Session.create({
        key: crypto.randomBytes(48),
        clientIpAddress: request.headers['x-forwarded-for'] || request.connection.remoteAddress
      }).success(function(session) {
        var chainer = new QueryChainer();
        chainer.add(session.setDevice(device));
        chainer.add(session.setApp(app));
        chainer.add(session.setUser(user));
        chainer.run().success(function(results) {
          callback(undefined, {
            key: session.key.toString('base64')
          });
        });
      });
    }

    async.parallel({
      user: findUser(request.body),
      app: findApp(request.body),
      device: findDevice(request)
    }, function(error, result) {
      if (!result.user) {
        callback(401, {
          error: "Unknown username or password."
        });
      } else if (!result.app) {
        callback(400, {
          error: "Unknown application key."
        });
      } else {
        beginSession(result.device, result.app, result.user, request, callback);
      }
    });
  }
}];
