var configuration = require('../configuration'),
  Sequalize = require('sequelize'),
  logger = require('./logger');

(function(configuration, Sequalize, logger) {
  function build_sequalize() {
    var options = configuration.database.options || {};
    options.logging = logger[configuration.sequelize.logging.level];

    if (configuration.database.connection_string_env) {
      return new Sequalize(process.env[configuration.database.connection_string_env], options);
    } else {
      return new Sequalize(configuration.database.database, configuration.database.username, configuration.database.password, options);
    }
  }

  var _data;

  module.exports = function() {
    if (!_data) {
      _data = build_sequalize();
    }
    _data.$ = function(name) {
      return this.import(__dirname + "/../models/" + name + ".js");
    };

    return _data;
  }();
})(configuration, Sequalize, logger);
