module.exports = function(sequelize, DataTypes) {
  var App = sequelize.define("app", {
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
    },
    platform: {
      type: DataTypes.STRING,
      allowNull: false,
    }
  });

  return App;
};
