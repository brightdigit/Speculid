var proxyquire = require('proxyquire').noCallThru();
var controller = proxyquire('../../../server/controllers/_controller.js', {
  '../libs/logger': {
    info: function() {}
  }
});

var controllers = {
  './name.js': [{
    "verb": "post",
    "callback": function(request, callback) {
      return true;
    }
  }]
};

var master = {
  configuration: {
    app: {
      basePath: "base/"
    }
  },
  sequelize: {

  },
  app: {
    post: function(path, cb) {
      this.registrations.post.push({
        path: path,
        cb: cb
      });
    },
    registrations: {
      "post": []
    }
  }
};

function req(path) {
  return controllers[path];
}

var item;

exports.setUp = function(cb) {
  item = controller.require('name', req);
  cb();
};

exports.initialize = function(test) {
  item.initialize(master);
  test.strictEqual(master.app.registrations.post[0].path, "base/name");
  test.done();
};
