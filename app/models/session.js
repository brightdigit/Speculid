module.exports = function(sequelize, DataTypes) {
  var User = sequelize.$('user'),
    App = sequelize.$('app');

  var Session = sequelize.define("session", {
    key: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
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

  return Session;
};
