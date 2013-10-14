var Sequelize = require('sequelize');
var async = require('async');
var sequelize = new Sequelize('rs-relations', 'rs-user');
var Registration = sequelize.define('registration', {

});

var User = sequelize.define('user', {
/*  emailAddress : {
    type : Sequelize.STRING
  }
*/});

User.belongsTo(Registration);

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
  async.parallel(
    {
      registration : create(Registration),
      user : create(User)
    },
    function (error, results) {
      results.user.setRegistration(results.registration);
    }
  );
  //var reg = Registration.create();
  //var user = User.create();

}).error(function (error) {
  console.log(error);
});