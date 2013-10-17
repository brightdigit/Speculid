var models = require('../models');

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
    User.find({
      where: {
        name: request.body.name,
        password: request.body.password
      }
    }).success(function(user) {
      if (user) {
        //user.hasDevice()
      } else {

      }

    });
  }
}];
