var proxyquire = require('proxyquire').noCallThru();

function configuration_create(node_env) {
  process.env.NODE_ENV = node_env;
  console.log(node_env);
  return proxyquire('../app/configuration', {
    path: {
      resolve: function(dir, file) {
        return file;
      },
      '@noCallThru': false
    },

    fs: {
      readdirSync: function(file) {
        return ['development.json', 'production.json'];
      }
    },

    envious: {
      apply: function() {
        return this[process.env.NODE_ENV];
      }
    },

    'development.json': {
      "name": "development"
    },
    'production.json': {
      "name": "production"
    }
  })
};

exports.production = function(test) {
  var configuration = configuration_create('production');
  test.ok(configuration.name == 'production');
  test.done();
};

exports.development = function(test) {
  var configuration = configuration_create('development');
  test.ok(configuration.name == 'development');
  test.done();
};
