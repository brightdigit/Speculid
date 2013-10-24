var path = require('path'),
  proxyquire = require('proxyquire'),
  Sequelize = require("sequelize");

module.exports = (function() {

  return function(name) {
    var sequelize = new Sequelize('tgio_test', null, null, {
      dialect: 'sqlite',
      logging: false
    });
    sequelize.$ = function(name) {
      return this.import(__dirname + "/../../server/models/" + name + ".js");
    };

    var models = proxyquire('../../server/models', {
      "../libs": {
        "sequelize": sequelize,
        "@noCallThru": false
      }
    });

    var controllerBase = require('../../server/controllers/_controller.js');

    var controller = proxyquire("../../server/controllers/" + name, {
      "../models": models
    });

    controller.find = controllerBase.find.bind(undefined, controller);
    controller.models = models;
    controller.sequelize = sequelize;

    controller._sync = function(cb) {
      sequelize.sync({
        force: true
      }).success(cb.bind(undefined, undefined)).error(cb);
    };

    controller.sync = function(cb) {

      return function(testcb) {
        sequelize.sync({
          force: true
        }).success(function() {
          cb(undefined, testcb);
        }).error(function(error) {
          cb(error, testcb);
        });
      };
    };

    controller.querychainer = function() {
      return new Sequelize.Utils.QueryChainer();
    };

    controller.name = name;

    return controller;
  };
})();
