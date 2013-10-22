var winston = require('winston'),
  configuration = require('../configuration');

module.exports = function(winston) {
  var transports = Object.keys(configuration.logging).map(function(name) {
    return new(winston.transports[name])(configuration.logging[name]);
  });
  return new(winston.Logger)({
    transports: transports
  });
}(winston);
