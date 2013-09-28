var proxyquire =  require('proxyquire');
var foo = proxyquire('../../app/controllers/Account.js', {});

exports.Register = {
	testValid :
		function(test){
		    var request = {
		    	body : {
		    		emailAddress : 'example@valid.com'
		    	}
		    };
    test.ok(false, "this assertion should fail");
    test.done();


		},
	testAlreadyExists : 
		function(test) {
    test.ok(false, "this assertion should fail");
    test.done();
		},
	testInvalidEmailAddress :
		function (test) {
    test.ok(false, "this assertion should fail");
    test.done();
		},
	testPropertyExists : 
		function (test) {
    test.ok(false, "this assertion should fail");
    test.done();
		},
}

exports.testSomethingElse = function(test){
    test.ok(false, "this assertion should fail");
    test.done();
};