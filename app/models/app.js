module.exports = function(sequelize, DataTypes) {
  //var User = sequelize.$('user');

  var App = sequelize.define("app", {
    name : {
      type : DataTypes.STRING,
      allowNull : false,
      unique : true
    },
    platform : {
      type : DataTypes.STRING,
      allowNull : false,
    }
  });

  //App.hasOne(User);

  return App;
};
