var configuration = require('../configuration');
Sequalize = require('sequelize');

(function(configuration, Sequalize) {
  function build_sequalize() {
    return new Sequalize(configuration.database.database, configuration.database.username, configuration.database.password, configuration.database.options);
  }

  var _data;

  module.exports = function() {
    if (!_data) {
      _data = build_sequalize();
    }

    return _data;
  }();
})(configuration, Sequalize);