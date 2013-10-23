var nodemailer = require('nodemailer');
var _ = require('underscore');
var templates = require('./templates.js')(__dirname + '/../templates');

module.exports = {
  queue: function(template, data, callback) {
    templates(template, data, function(error, mailOptions) {
      var smtpTransport = nodemailer.createTransport("SMTP", {
        service: "Gmail",
        auth: {
          user: "monit@brightdigit.com",
          pass: "monit5ervices"
        }
      });

      // send mail with defined transport object
      smtpTransport.sendMail(mailOptions, callback);
    });

  }
};
