var express = require('express');
var bodyParser = require('body-parser');
var app = express();
app.use(express.static(__dirname + '/../public'));
app.use(bodyParser());

/* istanbul ignore if */
if (require.main === module) {
  app.listen(process.env.PORT || 3000);
} else {
  module.exports = app;
}