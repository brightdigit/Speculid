var uuid = require('node-uuid');

module.exports = function(sequelize, DataTypes) {
  return sequelize.define("Request", {
    emailAddress: DataTypes.STRING,
    key: {
      type: 'BINARY(16)',
      get: function() {
        return uuid.unparse(this.getDataValue('key'));
      },
      set: function(v) {
        return uuid.parse(v);
      }
    },
    secret: {
      type: 'BINARY(16)',
      get: function() {
        return uuid.unparse(this.getDataValue('secret'));
      },
      set: function(v) {
        return uuid.parse(v);
      }
    },
  });
};