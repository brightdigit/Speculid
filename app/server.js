var express = require('express');
var app = express();
var Controllers = require('./controllers');
var sequelize = require('./controllers/data.js');
var configuration = require('./configuration');

app.use(express.bodyParser());

function http(func) {
  return function(req, res) {
    console.log('test');
    func(req, function(status, result) {
      status = status || 200;
      res.send(status, result);
    });
  };
}

app.post('/api/v1/register', function(req, res) {
  Controllers.Account.Register(req, function(status, result) {
    status = status || 200;
    res.send(status, result);
  });
});

app.post('/api/v1/confirm', function(req, res) {
  Controllers.Account.Confirm(req, function(result, status) {
    if (status == undefined) {
      res.send(result);
    } else {
      res.send(status, body);
    }
  });
});

app.post('/api/v1/login', function(req, res) {
  Controllers.Account.Login(req, function(result, status) {
    if (status == undefined) {
      res.send(result);
    } else {
      res.send(status, body);
    }
  });
});

sequelize.sync(configuration.sequelize.sync).success(function() {
  app.listen(3000);
  console.log('Listening on port 3000');
}).error(function(error) {
  console.log(error);
  process.exit(1);
});
