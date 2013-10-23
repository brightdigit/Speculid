var proxyquire = require('proxyquire');
var emailer = proxyquire('../../../server/libs/emailer.js', {
  nodemailer: {
    createTransport: function(type, settings) {
      return {
        sendMail: function(mailOptions, callback) {
          callback(undefined, mailOptions);
        }
      };
    }
  },
  './templates.js': function(dirname) {
    return function(name, data, cb) {
      cb(undefined, data);
    };
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
      test.strictEqual(response.name, "test");
      test.done();
    });
  }
};
