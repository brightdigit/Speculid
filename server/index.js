var express = require('express'),
  controllers = require('./controllers'),
  configuration = require('./configuration'),
  libs = require('./libs'),
  logger = libs.logger;

var app = express(),
  sequelize = libs.sequelize,
  logger = libs.logger;

app.use(controllers.initialize(configuration, sequelize, app));
app.use(express.bodyParser());
app.use(express.cookieParser({
  secret: configuration.app.secret
}));

app.use(function(request, response, next) {
  logger.debug("url: %s://%s%s \t %s", request.protocol, request.host, request.url, request.get('Referrer') || request.ip);
  next();
});

if (configuration.app.static) {
  app.use(express.static(__dirname + "/../" + configuration.app.static));
}

app.use(function(request, response, next) {
  next();
});

if (require.main === module) {
  controllers.listen(function(error, app) {
    if (error) {
      logger.error(error);
      process.exit(1);
    } else {
      app.listen(3000);
    }
  });
} else {
  module.exports = app;
}
