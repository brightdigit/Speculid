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
    classMethods: {
      createByName: function(name, key) {
        return App.create({
          name: name,
          key: key || crypto.randomBytes(48).toString('base64')
        });
      },
      findByKey: function(apiKey) {
        return App.find({
          where: {
            key: apiKey
          }
        });
      }
    }
  });

  return App;
};
