
/**
 * Module dependencies.
 */

var express = require('express');
var routes = require('./routes');
var user = require('./routes/user');
var http = require('http');
var path = require('path');
var Sequelize = require("sequelize");

var sequelize = new Sequelize ('sequelize-demo', 'sequelize-user');
console.log(sequelize);
var Project = sequelize.define('Project', {
  title: Sequelize.STRING,
  description: Sequelize.TEXT
});

var Task = sequelize.define('Task', {
  title: Sequelize.STRING,
  description: Sequelize.TEXT,
  deadline: Sequelize.DATE
});

Task.sync().success(function () {
  
  var task = Task.build({title: 'very important task'});
  task.save().error(function (err) {
    console.log(err);
  });
}).error(function (error) {
  console.log(error);
});


var app = express();

// all environments
app.set('port', process.env.PORT || 3000);
//app.set('views', __dirname + '/views');
//app.set('view engine', 'jade');
//app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.bodyParser());
//app.use(express.methodOverride());
//app.use(app.router);
//app.use(express.static(path.join(__dirname, 'public')));

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

//app.get('/', routes.index);
//app.get('/users', user.list);

app.get('/', function (request, response) {
  response.send(200);
});

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
