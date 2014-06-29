var crypto = require('crypto');

module.exports = function(sequelize, DataTypes) {
  //var User = sequelize.$('user');

  var UserAgent = sequelize.define("userAgent", {
    hash: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
    },
    text: {
      type: DataTypes.TEXT,
      allowNull: false,
      set: function(value) {
        var md5sum = crypto.createHash('md5');
        md5sum.update(value);
        this.setDataValue('text', value);
        this.setDataValue('hash', md5sum.digest('base64'));
      }
    }
  });

  //Company.hasMany(User, {as : "Developers"});
  //Company.hasOne(User, {as : "Contact"});

  return UserAgent;
};
