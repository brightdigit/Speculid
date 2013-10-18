var crypto = require('crypto');
module.exports = function(sequelize, DataTypes) {
  var App = sequelize.define("app", {
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
    },    
    key: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
    }
  }, {
    classMethods : 
      {
        createByName : function (name) {
          return App.create({name : name, key : crypto.randomBytes(48).toString('base64')});
        }
      }
  });

  return App;
};
