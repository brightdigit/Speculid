var express = require('express');
var app = express();
var controllers = require('./controllers');
var sequelize = require('./libs/sequelize.js');
var configuration = require('./configuration');

app.use(express.bodyParser());

controllers.initialize(configuration, sequelize, app);
controllers.listen(function(error) {
  console.log(error);
  process.exit(1);
});
