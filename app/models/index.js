var sequelize = require('../libs').sequelize;

function model (name) {
  return sequelize.import(__dirname + '/' + name + '.js');
}

module.exports = {
  registration : model('registration')
};