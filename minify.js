var Git = require('git-wrapper'),
  path = require('path');

var git = new Git ();
git.exec('ls-files', function (error, message) {
  console.log(message.split('\n'));
});