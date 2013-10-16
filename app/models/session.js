module.exports = function(sequelize, DataTypes) {
  var User = sequelize.$('user'),
    App = sequelize.$('app'),
    Device = sequelize.$('device');

  var Session = sequelize.define("session", {
    key: {
      type: DataTypes.BLOB('tiny'),
      allowNull: false
    },
    startedAt: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW
    },
    lastActivatedAt: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW
    },
    endedAt: {
      type: DataTypes.DATE,
      allowNull: true
    }
  });

  Session.belongsTo(User);
  Session.belongsTo(App);
  Session.belongsTo(Device);

  return Session;
};
