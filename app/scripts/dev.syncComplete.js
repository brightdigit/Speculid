var models = require('../models');

module.exports = function(cb) {
  models.app.createByName('default').success(cb.bind(undefined, undefined));
};
