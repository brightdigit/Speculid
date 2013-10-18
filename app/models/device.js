module.exports = function(sequelize, DataTypes) {
  var UserAgent = sequelize.$('userAgent');

  var Device = sequelize.define("device", {
    key: {
      type: DataTypes.BLOB('tiny'),
      allowNull: false
    }
  });

  Device.belongsTo(UserAgent);

  return Device;
};
