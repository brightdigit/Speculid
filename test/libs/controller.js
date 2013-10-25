var path = require('path'),
  proxyquire = require('proxyquire'),
  Sequelize = require("sequelize");

module.exports = (function() {

  return function(name, mocks) {
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
    mocks = mocks || {};
    mocks["../models"] = models;
    var controller = proxyquire("../../server/controllers/" + name, mocks);

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
          if (cb) {
            cb(undefined, testcb);
          } else {
            testcb();
          }
        }).error(function(error) {
          if (cb) {
            cb(error, testcb);
          } else {
            testcb();
          }
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
