var winston = require('winston');

module.exports = function(winston) {
  return new(winston.Logger)({
    transports: [
      new(winston.transports.Console)()
    ]
  });
}(winston);
