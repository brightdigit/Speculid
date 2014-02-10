define([
  'backbone'
], function(Backbone) {
  var UserModel = Backbone.Model.extend({
    url: '/api/v1/user'
  });

  return UserModel;
});
