var fs = require('fs'),
  path = require('path'),
  envious = require('envious');

module.exports = function(envious) {
  var files = fs.readdirSync(__dirname);
  files.forEach(function(file) {
    name = path.basename(file, '.json');
    try {
      envious[name] = require(path.resolve(__dirname, file));
    } catch (e) {
      console.log(e);
    }
  });
  return envious.apply();
}(envious);