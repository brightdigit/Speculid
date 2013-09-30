var nodemailer = require('nodemailer');
var _ = require('underscore');

module.exports = {
  templates: {},
  queue: function (template, data, callback) {
    var mailOptions = {};

    for (var name in template) {
      mailOptions[name] = template[name](data);
    }

    var smtpTransport = nodemailer.createTransport("SMTP", {
      service: "Gmail",
      auth: {
        user: "monit@brightdigit.com",
        pass: "monit5ervices"
      }
    });

    // send mail with defined transport object
    smtpTransport.sendMail(mailOptions, callback);
  }
};