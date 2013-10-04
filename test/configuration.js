var proxyquire = require('proxyquire');

function configuration (node_env) {
  process.env.NODE_ENV = node_env;
  return proxyquire('../app/configuration', 
  {
    path : {
      resolve : function (dir, file) {
        return file;
      } 
    },
    fs : {
      readdirSync : function (file) {

      }
    },
    envious : {
      apply : function () {

      }
    },

    'development.json' : {

    },
    'production.json' : {
      
    }
  })
}

exports.production = function (test) {
  process.env.NODE_ENV = 'production';
  var configuration = require('../app/configuration');
  test.ok(configuration.name == 'production');
  test.done();
};

exports.development = function (test) {
  process.env.NODE_ENV = 'development';
  console.log(process.env.NODE_ENV);
  var configuration = require('../app/configuration');
  console.log(configuration);
  test.ok(configuration.name == 'development');
  test.done();
};