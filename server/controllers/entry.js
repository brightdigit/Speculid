var async = require('async'),
  crypto = require('crypto'),
  models = require('../models'),
  QueryChainer = require('Sequelize').Utils.QueryChainer;

var Item = models.item,
  Entry = models.entry,
  Session = models.session;
App = models.app;

module.exports = [{
  /**
   * @api {post} /entry Creates a new entry.
   * @apiName PostEntry
   * @apiGroup Entry
   *
   * @apiParam {String} sessionKey Session Key.
   * @apiParam {String} apiKey Application Key.
   * @apiParam {String} item New Entry Item.
   *
   * @apiError SessionInformationIncorrect The session key and api key is invalid.
   *
   * @apiErrorExample Error-Response:
   *     HTTP/1.1 401 Not Found
   *     {
   *       "error": "SessionInformationIncorrect",
   *     }
   *
   * @apiError EntryInvalidName The entry name is invalid.
   *
   * @apiErrorExample Error-Response:
   *     HTTP/1.1 400 Not Found
   *     {
   *       "error": "EntryInvalidName",
   *     }
   */


  verb: 'post',
  callback: function(request, callback) {
    var queryChain = new QueryChainer();
    queryChain.add(Item.findOrCreate({
      name: request.body.item
    }));
    queryChain.add(Session.find({
      where: {
        key: new Buffer(request.body.sessionKey, 'base64'),
        clientIpAddress: request.headers['x-forwarded-for'] || request.connection.remoteAddress
      },
      include: [App]
    }));
    queryChain.run().success(function(results) {

      if (!results[1] || results[1].app.key !== request.body.apiKey) {
        callback(401, {
          error: "SessionInformationIncorrect"
        });
      } else if (results[0]) {
        Entry.create().success(function(entry) {
          var queryChain = new QueryChainer();
          queryChain.add(entry.setItem(results[0]));
          queryChain.add(entry.setSession(results[1]));
          queryChain.run().success(function() {
            callback();
          });
        });
      }
    }).error(function(error) {
      if (error[0].name) {
        callback(400, error[0]);
      } else {
        callback(500, error);
      }
    });
  }
}];
