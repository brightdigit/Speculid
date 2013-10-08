var fs = require('fs'),
  path = require('path'),
  envious = require('envious');

(function(fs, path, envious) {
  function build_configuration(fs, path, envious) {
    var files = fs.readdirSync(__dirname);
    files.forEach(function(file) {
      name = path.basename(file, '.json');
      try {
        envious[name] = require(path.resolve(__dirname, file));
      } catch (e) {
        console.log(e);
      }
    });
    return envious.apply({
      strict: true
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
