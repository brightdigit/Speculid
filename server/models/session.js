module.exports = function(sequelize, DataTypes) {
  var User = sequelize.$('user'),
    App = sequelize.$('app'),
    Device = sequelize.$('device');

  var Session = sequelize.define("session", {
    key: {
      type: DataTypes.BLOB('tiny'),
      allowNull: false
    },
    clientIpAddress: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        isIPv4: true
      }
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
  }, {
    instanceMethods: {
      renew: function() {
        this.lastActivatedAt = DataTypes.NOW;
        return this;
      },
      logoff: function() {
        this.endedAt = DataTypes.NOW;
        return this;
      }
    }
  });

  Session
    .belongsTo(User)
    .belongsTo(App)
    .belongsTo(Device);

  return Session;
};
