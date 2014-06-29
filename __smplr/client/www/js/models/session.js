define([
  'backbone'
], function(Backbone) {
  var SessionModel = Backbone.Model.extend({
    url: '/api/v1/session'
  });

  return SessionModel;
});
