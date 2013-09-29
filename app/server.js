
var express = require('express');
var app = express();
app.use(express.bodyParser());
var Controllers = require('./controllers');

app.post('/api/v1/register', function(req, res){
	console.log(req.body);
	Controllers.Account.Register(req, function (result, status) {
		if (status == undefined) {
			res.send(result);
		} else {
			res.send(status, result);
		}
	});
});

app.post('/api/v1/confirm', function(req, res){
	Controllers.Account.Confirm(req, function (result, status) {
		if (status == undefined) {
			res.send(result);
		} else {
			res.send(status, body);
		}
	});
});

app.post('/api/v1/login', function(req, res){
	Controllers.Account.Login(req, function (result, status) {
		if (status == undefined) {
			res.send(result);
		} else {
			res.send(status, body);
		}
	});
});
app.listen(3000);
console.log('Listening on port 3000');


/*
 set mailserver smtp.gmail.com port 587
		username "monit@brightdigit.com" password "monit5ervices"
		using tlsv1
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
	}

	// if you don't want to use this transport object anymore, uncomment following line
	//smtpTransport.close(); // shut down the connection pool, no more messages
});
*/