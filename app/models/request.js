module.exports = function(sequelize, DataTypes) {
  return sequelize.define("Request", {
    emailAddress: DataTypes.STRING,
    key: DataTypes.UUID,
    secret: DataTypes.UUID
  });
};