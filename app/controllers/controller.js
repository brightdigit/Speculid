module.exports = (function () {
  var _S = {
    

  };

  function path (controller, verb) {
    this.verb = verb.verb;
    this.implementation = verb.callback;
    this._path = verb.path;
    this.controller = controller;
  }

  path.prototype = {
    verb : undefined,
    _path : undefined,
    implementation : undefined,
    callback : function (req, res) {
      this.implementation(req, path.result(res));
    },
    getPath : function () {
      return this._path || this.controller.master.configuration.app.basePath + this.controller.name;
    }
  }

  path.result = function (resp) {
    function _result (resp, status, result) {
      status = status || 200;
      resp.send(status, result);
    }

    return _result.bind(undefined, resp);
  };

  path.callback = function (item) {
    return item.callback.bind(item);
  };

  path.getPath = function (controller, verb) {
    if (verb.path) {
      return controller.configuration.app.basePath + verb.path;
    }

  };
/*
function http(func) {
  return function(req, res) {
    func(req, function(status, result) {
      status = status || 200;
      res.send(status, result);
    });
  };
}
*/

  function priv (obj, name) {
    var __P = {
      register : function (item, index) {
        console.log([item.verb, item.getPath(this.master)].join(': '));
        this.master.app[item.verb](item.getPath(this.master), path.callback(item));
      },
      callback : function (verb) {
        return new path (this, verb);
      }
    };
    return __P[name].bind(obj);
  }

  var controller = function (name, verbs) {
    this.name = name;
    this.paths = verbs.map(priv(this, 'callback'));
  };

  controller.prototype = {
    initialize : function (master) {
      this.master = master;
      this.paths.forEach(priv(this, 'register'));
    }
  };

  controller.require = function (name) {
    return new controller(name, require('./' + name + '.js'));
  };

  return controller;

})();