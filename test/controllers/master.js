var proxyquire = require('proxyquire').noCallThru();
var master = proxyquire('../../app/controllers/master.js', {
  './test.js': {
    'test': {
      value: true
    },
    initialize: function(master) {
      this.master = master;
    }
  },
  './controller' : function (data) {
    return data;
  }
});

var app = {
  listen: function() {
    this.active = true;
  }
};

var sequelize = {
  sync: function() {
    return this;
  },
  success: function(cb) {
    cb();
    return this;
  },
  error: function(cb) {
    return this;
  }
};

var configuration = {
  sequelize: {
    sync: {

    }
  }
};

var example;

exports.setUp = function(cb) {
  example = new master('test');
  example.initialize(configuration, sequelize, app);
  cb();
};

exports.constructor = function(test) {
  test.ok(example.controllers.test.test.value);
  test.done();
};

exports.initialize = function(test) {
  test.strictEqual(example.controllers.test.master.app, app);
  test.strictEqual(example.controllers.test.master.sequelize, sequelize);
  test.strictEqual(example.controllers.test.master.configuration, configuration);
  test.done();
};

exports.listen = function(test) {
  test.ok(!app.active);
  example.listen();
  test.ok(app.active);
  test.done();
};
