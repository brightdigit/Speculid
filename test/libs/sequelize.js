var Sequelize = require('sequelize');

(function(Sequelize) {
  function build_sequelize() {
    return new Sequelize('tgio_test', null, null, {
      dialect: 'sqlite',
      logging: false
    });
  }

  var _data;

  module.exports = function() {
    if (!_data) {
      _data = build_sequelize();
    }

    _data.$ = function(name) {
      return this.import(__dirname + "/../../server/models/" + name + ".js");
    };


    return _data;
  }();
})(Sequelize);
