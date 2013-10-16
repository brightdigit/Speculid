var sequelize = require('../libs').sequelize,
  indexer = require('../libs').indexer;

function model(name) {
  return sequelize.$(name);
}

function modelObj(obj) {
  function _modelObj (obj, name) {
    obj[name] = model(name);
  }

  return _modelObj.bind(undefined, obj);
}

function models(names) {
  var obj = {};
  names.forEach(modelObj(obj));
  return obj;
}

module.exports = indexer(__dirname, models);


