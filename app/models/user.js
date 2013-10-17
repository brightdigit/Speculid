module.exports = function(sequelize, DataTypes) {
  var Registration = sequelize.$('registration'),
    App = sequelize.$('app'),
    Device = sequelize.$('device'),
    Company = sequelize.$('company');

  var User = sequelize.define("user", {
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
      validate: {
        is: ["[a-z][a-z0-9-]{5,15}"]
      }
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    emailAddress: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        isEmail: true
      }
    }
  });

  User
    .belongsTo(Company)
    .belongsTo(Registration)
    .hasMany(App)
    .hasMany(Device)
    .hasOne(Company, {
      as: 'contact',
      foreignKey: 'contactId'
    });

  Device.hasMany(User);

  return User;
};
