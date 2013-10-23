module.exports = function(sequelize, DataTypes) {
  var Privilege = sequelize.$('privilege');

  var Role = sequelize.define("role", {
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
    }
  });

  Role.hasMany(Privilege);
  Privilege.hasMany(Role);

  return Role;
};
