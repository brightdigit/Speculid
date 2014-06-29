var Sequelize = require('sequelize');
var async = require('async');
var crypto = require('crypto');
var sequelize = new Sequelize('rs-relations', 'rs-user', null, {logging : true});
var Registration = sequelize.define('registration', {
  key : Sequelize.BLOB('tiny')
});


//User.belongsTo(Registration);

function create (seq) {
  function _success (cb, seq) {
    cb(undefined, seq);
  }

  function _create (seq, cb) {
    seq.create().success(_success.bind(undefined, cb));
  }

  return _create.bind(undefined, seq);
}


sequelize.sync({force : true}).success(function () {
  var key = crypto.randomBytes(48);
  Registration.create({key : key}).success( function (registration) {
    var keyStr = key.toString('base64');
    console.log(keyStr);
    Registration.find({where :{key : key}}).success( function (registration) {
      console.log(registration.key);
    }).error( function (error) {
      console.log(error);
    });
  //});

  /*
  async.parallel(
    {
      registration : create(Registration),
      user : create(User)
    },
    function (error, results) {
      results.user.setRegistration(results.registration);
    }
  );
*/
  //var reg = Registration.create();
  //var user = User.create();

}).error(function (error) {
  console.log(error);
});
});