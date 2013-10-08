var bcrypt = require('bcrypt');
var sequelize = require('../controllers/data.js');

module.exports = function(sequelize, DataTypes) {
  return sequelize.define("Account", {
    emailAddress: DataTypes.STRING,
    userName: DataTypes.STRING,
    password: DataTypes.STRING
  });
};
