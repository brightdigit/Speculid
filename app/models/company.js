module.exports = function(sequelize, DataTypes) {
  //var User = sequelize.$('user');

  var Company = sequelize.define("company", {
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
    }
  });

  //Company.hasMany(User, {as : "Developers"});
  //Company.hasOne(User, {as : "Contact"});

  return Company;
};
