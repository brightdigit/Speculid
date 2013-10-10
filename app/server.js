var express = require('express');
var app = express();
var controllers = require('./controllers');
var sequelize = require('./libs/sequelize.js');
var configuration = require('./configuration');

app.use(express.bodyParser());

function http(func) {
  return function(req, res) {
    func(req, function(status, result) {
      status = status || 200;
      res.send(status, result);
    });
  };
}

app.post('/api/v1/register', function(req, res) {
  controllers.registration.Register(req, function(status, result) {
    status = status || 200;
    res.send(status, result);
  });
});

sequelize.sync(configuration.sequelize.sync).success(function() {
  app.listen(3000);
  console.log('Listening on port 3000');
}).error(function(error) {
  console.log(error);
  process.exit(1);
});
