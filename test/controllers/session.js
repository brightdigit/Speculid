var proxyquire = require('proxyquire').noCallThru();

/*
function mockModel(data) {
  this.__empty = !data;
  for (var key in data) {
    this[key] = data[key];
  }
}

mockModel.prototype.__type = function(typeName) {
  this.__type = typeName;
  return this;
};

mockModel.prototype.create = function(data) {
  var model = new mockModel(data);
  if (this.__type === 'user' && data.name === '') {
    model._error = {
      'name': 'User name invalid'
    };
  }
  return model;
};

mockModel.prototype.find = function(query) {
  if (this.__type === 'user' && query.where.name === 'nameAlreadyInUse') {
    return new mockModel({}).__type('user');
  } else if (this.__type === 'registration' && query.where[1] !== 'registrationNotFound@valid.com') {
    return new mockModel({
      emailAddress: query.where[1]
    }).__type("registration");
  }
  return new mockModel();
};

mockModel.prototype.save = function() {
  return this;
};

mockModel.prototype.success = function(cb) {
  if (!this._error) {
    cb(this.__empty ? null : this);
  }

  return this;
};

mockModel.prototype.error = function(cb) {
  if (this._error) {
    cb(this._error);
  }

  return this;
};

mockModel.prototype.setRegistration = function(cb) {
  return this;
};
*/

function models (_) {
  return {
    App : function findByKey (apiKey) {
      return apiKey === 'apiKey';
    },
    User : function findByLogin (name, password) {
      console.log('test');
      return name === 'example' && password === 'test';
    
    }
  }
}

var controller = require('../../server/controllers/_controller.js');
var session = proxyquire('../../server/controllers/session.js',{ models : models( {
  "user" : {
    find : function (where) {
      return where.name === 'validName' && where.password === 'password';
    }
  },
  "app" : {
    find : function (where) {
      return where.key == 'apiKey';
    }
  }
})});

exports.session = {
  testValid: function(test) {
    var request = {
      body: {
        apiKey: 'key',
        name: 'example',
        password: 'test'
      },
      headers : {
        'user-agent' : 'user agent 1.0'
      }
    };
    controller.find(session, {
      "verb": "post"
    })(request,
      function(status, result) {
        test.ok(status === 200 || status === undefined);
        test.done();
      });
  },
  testInvalidLogin: function(test) {
    var request = {
      body: {
        apiKey: 'key',
        name: 'example',
        password: 'test'
      },
      headers : {
        'user-agent' : 'user agent 1.0'
      }
    };
    controller.find(session, {
      "verb": "post"
    })(request,
      function(status, result) {
        test.equals(status, 401);
        test.ok( !! result.error);
        test.done();
      });
  },
  testInvalidApp: function(test) {
    var request = {
      body: {
        apiKey: 'key',
        name: 'example',
        password: 'test'
      },
      headers : {
        'user-agent' : 'user agent 1.0'
      }
    };
    controller.find(session, {
      "verb": "post"
    })(request,
      function(status, result) {
        test.equals(status, 400);
        test.ok( !! result.error);
        test.done();
      });
  }
};

