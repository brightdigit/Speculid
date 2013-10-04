var uuid = require('node-uuid'),
  emailer = require('./emailer.js'),
  sequelize = require('./data.js'),
  account_request = sequelize.import(__dirname + '/../models/request.js');

module.exports = {
  Register: function(request, callback) {
    //callback(400);
    //return;
    // error || {
    // key: ar.key
    //});
    var secret, key;
    var emailAddress = request.body.emailAddress;


    var data = {
      emailAddress: request.body.emailAddress,
      secret: uuid.v4(),
      key: uuid.v4()
    };
    //var ar = account_request.build(data);

    emailer.queue('confirmation', {
      emailAddress: data.emailAddress,
      secret: data.secret
    }, function(error, response) {
      callback(undefined, {
        key: data.key
      });
    });

    return;
    ar.save().success(function(ar) {
      callback(undefined, {
        key: ar.key
      });
      /*
      emailer.queue('confirmation', {
        emailAddress: ar.emailAddress,
        secret: ar.secret
      }, function(error, response) {
        
      });
*/
    }).error(function(error) {
      if (error) {
        callback(400, error);
        return;
      }
    });
    // verify emailAddress
    // property exists
    // valid
    // isn't already used

    /*
    emailer.aend('confirmation', {emailAddress : emailAddress, secret : secret}, function (error, response) {
      // what to do if error
      callback({key: uuid.v4()});
    });
    var nodemailer = require("nodemailer");
    var uuid = require('node-uuid');

    // create reusable transport method (opens pool of SMTP connections)
    var smtpTransport = nodemailer.createTransport("SMTP",{
      service: "Gmail",
      auth: {
        user: "monit@brightdigit.com",
        pass: "monit5ervices"
      }
    });

    // setup e-mail data with unicode symbols
    var mailOptions = {
      from: "monit@brightdigit.com", // sender address
      to: "leogdion@brightdigit.com", // list of receivers
      subject: "Confirmation Email", // Subject line
      text: uuid.v4(), // plaintext body
    }

    // send mail with defined transport object
    smtpTransport.sendMail(mailOptions, function(error, response){
      if(error){
          console.log(error);
      }else{
          console.log("Message sent: " + response.message);
          callback({key: uuid.v4()});
      }

      // if you don't want to use this transport object anymore, uncomment following line
      //smtpTransport.close(); // shut down the connection pool, no more message
    });
*/
  },
  Confirm: function(request) {

  },
  Login: function(request) {

  }
};