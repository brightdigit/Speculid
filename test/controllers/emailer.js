var proxyquire = require('proxyquire');
var emailer = proxyquire('../../app/controllers/emailer.js', {
  nodemailer: {
    createTransport: function(type, settings) {
      return {
        sendMail: function(mailOptions, callback) {
          callback(undefined, mailOptions);
        }
      }
    }
  }
});

exports.queue = {
  testValid: function(test) {
    var example = {
      body: function(data) {
        return data.name;
      }
    };
    emailer.queue(example, {
      name: "test"
    }, function(error, response) {
      //test.ok(false, "this assertion should fail");
      test.strictEqual(response.body, "test");
      test.done();
    });
  }
};
