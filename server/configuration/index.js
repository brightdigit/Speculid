var fs = require('fs'),
  path = require('path'),
  merge = require('deepmerge'),
  envious = require('envious'),
  crypto = require('crypto'),
  defaultOptions = require('./_default.json');

var key = fs.readFileSync(path.join(__dirname, "../..", ".keyfile"), 'utf8');

(function(fs, path, envious) {

  function build_configuration(fs, path, envious) {
    var files = fs.readdirSync(__dirname);
    files.forEach(function(file) {
      if (file[0] != '_') {
        name = path.basename(file, '.json');
        var text, secure = path.join(__dirname, '..', 'secure', name + ".json.encrypted");
        if (key && fs.existsSync(secure)) {
          var crypted = fs.readFileSync(secure, 'utf8'),
            decipher = crypto.createDecipher('aes-256-cbc', key);
          text = decipher.update(crypted, 'hex', 'utf8') + decipher.final('utf8');
        }
        envious[name] = merge(merge(defaultOptions, require(path.resolve(__dirname, file))), text ? JSON.parse(text) : {});
      }
    });
    envious.default_env = "development";
    var conf = envious.apply({
      strict: true,
      strictProperties: true
    });

    conf.script = function(name, cb) {
      var method;
      if (this.app.scripts[name]) {
        try {
          method = require("../scripts/" + this.app.scripts[name] + ".js");
        } catch (e) {
          console.log(e);

        }
      }
      if (method) {
        method(cb);
      } else {
        cb();
      }
    };

    return conf;
  }

  var _configuration;

  module.exports = function(fs, path, envious) {
    if (!_configuration) {
      _configuration = build_configuration(fs, path, envious);
    }

    return _configuration;
  }(fs, path, envious);

})(fs, path, envious);
