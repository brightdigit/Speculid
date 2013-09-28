var proxyquire =  require('proxyquire');
var foo = proxyquire('../../app/controllers/Account.js');

exports.Register = {
	testValid :
		function(test){
		    var request = {
		    	body : {
		    		emailAddress : 'example@valid.com'
		    	}
		    };

		},
	testAlreadyExists : 
		function(test) {
    test.ok(false, "this assertion should fail");
		},
	testInvalidEmailAddress :
		function (test) {
    test.ok(false, "this assertion should fail");
		},
	testPropertyExists : 
		function (test) {
    test.ok(false, "this assertion should fail");
		},
}

exports.testSomethingElse = function(test){
    test.ok(false, "this assertion should fail");
    test.done();
};