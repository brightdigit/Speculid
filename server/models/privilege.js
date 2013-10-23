module.exports = function(sequelize, DataTypes) {
  var Privilege = sequelize.define("privilege", {
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
    }
  });

  return Privilege;
};
