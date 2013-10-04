var bcrypt = require('bcrypt'),
  configuration = require('../configuration.js'),
  Sequelize = require('sequelize');

module.exports = function(sequelize, DataTypes) {
  return sequelize.define("Account", {
    emailAddress: DataTypes.STRING,
    userName: DataTypes.STRING,
    password: DataTypes.STRING
  });
};