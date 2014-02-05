var controller = require('./_controller'),
  configuration = require('../configuration'),
  logger = require('../libs').logger;

var initialized = false;

module.exports = (function() {
  var _ = {
    loadControllers: function(names) {
      var controllers = {};
      names.forEach(function(name) {
        controllers[name] = controller.require(name);
      });
      return controllers;
    }
  };

  var master = function() {
    if (typeof(arguments[0]) === 'string') {
      this.controllers = _.loadControllers(Array.prototype.slice.call(arguments));
    } else if (Object.prototype.toString.call(arguments[0]) === '[object Array]') {
      this.controllers = _.loadControllers(arguments[0]);
    }
  };

  master.prototype = {
    controllers: [],
    initialize: function(configuration, sequelize, app) {
      this.configuration = configuration;
      this.sequelize = sequelize;
      this.app = app;
      for (var name in this.controllers) {
        if (typeof(this.controllers[name].initialize) === 'function') {
          this.controllers[name].initialize(this);
        }
      }
      return this.initializer.bind(this);
    },
    syncComplete: function(cb, error) {
      var that = this;
      if (error) {
        cb(error);
      } else {
        configuration.script("syncComplete", function(error, result) {
          if (result) {
            logger.debug(result.key);
          }
          if (cb) {
            initialized = true;
            cb(undefined, that.app);
          }
        });
      }
    },
    listen: function(cb) {
      this.sequelize
        .sync(this.configuration.sequelize.sync)
        .success(this.syncComplete.bind(this, cb, undefined))
        .error(this.syncComplete.bind(this, cb));
    },
    initializer: function(request, response, next) {
      if (initialized) {
        next();
      } else {
        this.sequelize
          .sync(this.configuration.sequelize.sync)
          .success(this.syncComplete.bind(this, next, undefined))
          .error(this.syncComplete.bind(this, next));
      }
    }
  };

  master.fromControllers = function() {
    return new master(arguments[0]);
  };

  return master;
})();
