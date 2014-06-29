var logger = require('../libs/logger');

module.exports = (function() {
  var _S = {};

  function path(controller, verb) {
    this.verb = verb.verb;
    this.implementation = verb.callback;
    this._path = verb.path;
    this.controller = controller;
  }

  path.prototype = {
    verb: undefined,
    _path: undefined,
    implementation: undefined,
    callback: function(req, res) {
      this.implementation(req, path.result(res));
    },
    getPath: function() {
      return this._path || this.controller.master.configuration.app.basePath + this.controller.name;
    }
  };

  path.result = function(resp) {
    function _result(resp, status, result, headers) {
      status = status || 200;
      if (headers) {
        resp.set(headers);
      }
      resp.send(status, result);
    }

    return _result.bind(undefined, resp);
  };

  path.callback = function(item) {
    return item.callback.bind(item);
  };

  path.getPath = function(controller, verb) {
    if (verb.path) {
      return controller.configuration.app.basePath + verb.path;
    }

  };

  function priv(obj, name) {
    var __P = {
      register: function(item, index) {
        logger.info("%s: %s", item.verb, item.getPath());
        this.master.app[item.verb](item.getPath(this.master), path.callback(item));
      },
      callback: function(verb) {
        return new path(this, verb);
      }
    };
    return __P[name].bind(obj);
  }

  var controller = function(name, verbs) {
    this.name = name;
    this.paths = verbs.map(priv(this, 'callback'));
  };

  controller.prototype = {
    initialize: function(master) {
      this.master = master;
      this.paths.forEach(priv(this, 'register'));
    }
  };

  controller.require = function(name, req) {
    req = req || require;
    return new controller(name, req('./' + name + '.js'));
  };

  controller.find = function(array, filter) {
    var path;
    for (var index = 0; index < array.length; index++) {
      path = array[index];
      if (typeof(filter) === 'function') {
        if (filter(path)) {
          return path.callback;
        }
      } else {
        if ((path.path === filter.path || filter.path === 'undefined') && (path.verb === filter.verb || filter.verb === undefined)) {
          return path.callback;
        }
      }
    }
  };

  return controller;

})();
