var express = require('express'),
  controllers = require('./controllers'),
  configuration = require('./configuration'),
  libs = require('./libs');

var app = express(),
  sequelize = libs.sequelize,
  logger = libs.logger;

app.use(express.bodyParser());
app.use(express.cookieParser({
  secret: configuration.app.secret
}));

controllers.initialize(configuration, sequelize, app);
controllers.listen(function(error) {
  logger.error(error);
  process.exit(1);
});
