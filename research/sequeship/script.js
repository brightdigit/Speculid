var Sequelize = require('sequelize');

var sequelize = new Sequelize('rs-relations', 'rs-user');
var Registration = sequelize.define('registration', {

});

var User = sequelize.define('user', {
/*  emailAddress : {
    type : Sequelize.STRING
  }
*/});

User.belongsTo(Registration);

sequelize.sync({force : true}).success(function () {
  var reg = Registration.create();
  var user = User.create();
  reg.setUser(user);
}).error(function (error) {
  console.log(error);
});