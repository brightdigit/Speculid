var uuid = require('node-uuid');

module.exports = function(sequelize, DataTypes) {
  return sequelize.define("registration", {
    emailAddress: DataTypes.STRING,
    key: DataTypes.BLOB('tiny'),
    secret: DataTypes.BLOB('tiny')
  });
};
