module.exports = function(sequelize, DataTypes) {
  var Registration = sequelize.import(__dirname + '/registration.js');

  var User = sequelize.define("user", {
    name : {
      type : DataTypes.STRING,
      allowNull : false,
      unique : true,
      validate : {
        is: ["[a-z][a-z0-9-]{5,15}"] 
      }
    },
    password : {
      type : DataTypes.STRING,
      allowNull : false,
    },
    emailAddress: {
      type : DataTypes.STRING,
      allowNull : false,
      validate: {
        isEmail : true
      }
    }
  });

  User.hasOne(Registration);

  return User;
};
