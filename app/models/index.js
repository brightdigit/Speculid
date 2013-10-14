var sequelize = require('../libs').sequelize;

function model(name) {
  return sequelize.$(name);
}

function modelObj(obj) {
  function _modelObj (obj, name) {
    obj[name] = model(name);
  }

  return _modelObj.bind(undefined, obj);
}

function models() {
  var obj = {};
  Array.prototype.forEach.call(arguments, modelObj(obj));
  return obj;
}

module.exports = models('registration', 'user', 'app');


