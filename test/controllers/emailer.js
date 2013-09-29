var proxyquire = require('proxyquire');
var emailer = proxyquire('../../app/controllers/emailer.js', {
  nodemailer : {
    createTransport : function (type, settings) {
      return null;
    }
  }
});

exports.queue = {
  testValid: function (test) {
    test.ok(false, "this assertion should fail");
    test.done();
  }
};