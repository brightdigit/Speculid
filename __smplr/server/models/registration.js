module.exports = function(sequelize, DataTypes) {
  var App = sequelize.$('app');

  var Registration = sequelize.define("registration", {
    emailAddress: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        isEmail: true
      }
    },
    key: {
      type: DataTypes.BLOB('tiny'),
      allowNull: false
    },
    secret: {
      type: DataTypes.BLOB('tiny'),
      allowNull: false
    },
    registeredAt: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW
    }
  });

  Registration.belongsTo(App);

  return Registration;
};
