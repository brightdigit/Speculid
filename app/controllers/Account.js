module.exports = {
  Register: function(request, callback) {
    var uuid = require('node-uuid');
    var secret, key;
    console.log(request.body);
    emailAddress = request.body.emailAddress;

    // verify emailAddress
    // property exists
    // valid
    // isn't already used

    secret = uuid.v4();
    key = uuid.v4();

    callback({
      key: uuid.v4()
    });
    /*
    emailer.aend('confirmation', {emailAddress : emailAddress, secret : secret}, function (error, response) {
      // what to do if error
      callback({key: uuid.v4()});
    });
*/
    /*
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