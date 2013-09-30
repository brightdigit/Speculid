var proxyquire = require('proxyquire').noCallThru();
var verify = {};
var lsr = proxyquire('../../app/controllers/lsr.js', {
  fs : {
    readdir : function (path, cb) {

    }
  },
  async : {
    concat : function (items) {
      
    }
  },
  path : {}
});

exports.readir = function (test) {
  lsr('path', function (error, results) {

  }); 
};