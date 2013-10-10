var controller = require('./controller');

module.exports = (function() {
  var _ = {
    loadControllers: function(names) {
      var controllers = {};
      names.forEach(function(name) {
        controllers[name] = new controller(require('./' + name + '.js'));
      });
      return controllers;
    }
  };

  var master = function() {
    this.controllers = _.loadControllers(Array.prototype.slice.call(arguments));
  };

  master.prototype = {
    controllers: [],
    initialize: function(configuration, sequelize, app, cb) {
      this.configuration = configuration;
      this.sequelize = sequelize;
      this.app = app;
      this.cb = cb;
      for (var name in this.controllers) {
        if (typeof(this.controllers[name].initialize) === 'function') {
          this.controllers[name].initialize(this);
        }
      }
    },
    syncComplete: function(error) {
      if (error) {
        this.cb(error);
      } else {
        this.app.listen(3000);
      }
    },
    listen: function() {
      this.sequelize
        .sync(this.configuration.sequelize.sync)
        .success(this.syncComplete.bind(this))
        .error(this.syncComplete.bind(this));
    }
  };

  return master;
})();
