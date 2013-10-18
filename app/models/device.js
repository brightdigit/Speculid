var QueryChainer = require('Sequelize').Utils.QueryChainer;

module.exports = function(sequelize, DataTypes) {
  var UserAgent = sequelize.$('userAgent');

  var Device = sequelize.define("device", {
    key: {
      type: DataTypes.BLOB('tiny'),
      allowNull: false
    }
  }, {
    classMethods : {
      findByKey : function (key, userAgent, cb) {
        var keyBuffer = new Buffer (key, 'base64');
        Device.find({where : ['`key` = ?', keyBuffer]}).success(
          function (device) {
            var chainer = new QueryChainer();
            chainer.add(Device.create({key : keyBuffer}));
            chainer.add(UserAgent.findOrCreate({text : userAgent}));
            chainer.run().success( function (results) {
              results[0].setUserAgent(results[1]).success(cb);
            });
          }
        );
      }
    }
  });

  Device.belongsTo(UserAgent);

  return Device;
};
