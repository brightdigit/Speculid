var express = require('express');
var bodyParser = require('body-parser');
var roust = require('../roust');
var app = express();
app.roust('/api/v1', [__dirname + '/controllers']);
app.use(express.static(__dirname + '/../public'));

// parse application/json
app.use(bodyParser.json());

/* istanbul ignore if */
if (require.main === module) {
  app.listen(process.env.PORT || 3000);
} else {
  module.exports = app;
}