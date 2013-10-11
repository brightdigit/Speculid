var controller = require('./controller');

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
    this.controllers = _.loadControllers(Array.prototype.slice.call(arguments));
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
    },
    syncComplete: function(cb, error) {
      if (error) {
        cb(error);
      } else {
        this.app.listen(3000);
      }
    },
    listen: function(cb) {
      this.sequelize
        .sync(this.configuration.sequelize.sync)
        .success(this.syncComplete.bind(this, cb, undefined))
        .error(this.syncComplete.bind(this, cb));
    }
  };

  return master;
})();
