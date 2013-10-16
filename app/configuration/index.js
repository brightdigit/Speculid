var fs = require('fs'),
  path = require('path'),
  merge = require('deepmerge'),
  envious = require('envious'),
  defaultOptions = require('./_default.json');

(function(fs, path, envious) {

  function build_configuration(fs, path, envious) {
    var files = fs.readdirSync(__dirname);
    files.forEach(function(file) {
      if (file[0] != '_') {
        name = path.basename(file, '.json');
        envious[name] = merge(defaultOptions, require(path.resolve(__dirname, file)));
      }
    });
    envious.default_env = "development";
    return envious.apply({
      strict: true,
      strictProperties: true
    });
  }

  var _configuration;

  module.exports = function(fs, path, envious) {
    if (!_configuration) {
      _configuration = build_configuration(fs, path, envious);
    }

    return _configuration;
  }(fs, path, envious);

})(fs, path, envious);
