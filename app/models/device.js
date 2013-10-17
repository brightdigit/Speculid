module.exports = function(sequelize, DataTypes) {
  var Device = sequelize.define("device", {
    key: {
      type: DataTypes.BLOB('tiny'),
      allowNull: false
    },
    userAgent: {
      type: DataTypes.STRING,
      allowNull: true
    }
  });

  return Device;
};
