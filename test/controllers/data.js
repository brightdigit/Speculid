var proxyquire = require('proxyquire').noCallThru();

var configuration = {
  'database': {
    'username': 'username',
    'password': 'password',
    'database': 'database',
    'options': {
      'test': true
    }
  }
};

var data = proxyquire('../../app/controllers/data.js', {
  '../configuration': configuration,
  'sequalize': function() {
    this.arguments = Array.prototype.slice.call(arguments, 0);
  }
});

exports.sequalize = function(test) {
  test.strictEqual(data.arguments[0], configuration.database.database);
  test.strictEqual(data.arguments[1], configuration.database.username);
  test.strictEqual(data.arguments[2], configuration.database.password);
  test.deepEqual(data.arguments[3], configuration.database.options);
  test.done();
};