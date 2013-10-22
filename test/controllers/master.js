var proxyquire = require('proxyquire').noCallThru();
var master = proxyquire('../../app/controllers/_master.js', {
  './test.js': {
    'test': {
      value: true
    },
    initialize: function(master) {
      this.master = master;
    }
  },
  './_controller': {
    require: function(name) {
      if (name === 'test') {
        return {
          initialize: function(master) {
            this.master = master;
          },
          test: {
            'value': true
          }
        };
      }
    }
  },
  '../configuration': {
    script: function(name, cb) {
      cb();
    }
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

exports.asList = {
  setUp: function(cb) {
    example = new master('test');
    example.initialize(configuration, sequelize, app);
    cb();
  },
  constructor: function(test) {
    test.ok(example.controllers.test.test.value);
    test.done();
  },
  initialize: function(test) {
    test.strictEqual(example.controllers.test.master.app, app);
    test.strictEqual(example.controllers.test.master.sequelize, sequelize);
    test.strictEqual(example.controllers.test.master.configuration, configuration);
    test.done();
  },
  listen: function(test) {
    test.ok(!app.active);
    example.listen();
    test.ok(app.active);
    test.done();
  },
  tearDown: function(cb) {
    example = undefined;
    app.active = false;
    cb();
  }
};

exports.asArray = {
  setUp: function(cb) {
    example = new master(['test']);
    example.initialize(configuration, sequelize, app);
    cb();
  },
  constructor: function(test) {
    test.ok(example.controllers.test.test.value);
    test.done();
  },
  initialize: function(test) {
    test.strictEqual(example.controllers.test.master.app, app);
    test.strictEqual(example.controllers.test.master.sequelize, sequelize);
    test.strictEqual(example.controllers.test.master.configuration, configuration);
    test.done();
  },
  listen: function(test) {
    test.ok(!app.active);
    example.listen();
    test.ok(app.active);
    test.done();
  },
  tearDown: function(cb) {
    example = undefined;
    app.active = false;
    cb();
  }
};
