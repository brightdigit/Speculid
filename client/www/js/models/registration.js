define([
  'backbone'
], function(Backbone) {
  var RegistrationModel = Backbone.Model.extend({
    url: '/api/v1/registration'
  });

  return RegistrationModel;
});
