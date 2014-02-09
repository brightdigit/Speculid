define([
  'jquery',
  'backbone',
  'views/loginregistration'
], function($, Backbone, LoginRegistration) {
  var AppRouter = Backbone.Router.extend({
    routes: {
      // Define some URL routes
      "": 'login',
      "/": 'login',
      '/login': 'login',

      // Default
      '*': 'login',
    }
  });

  var initialize = function() {
    var app_router = new AppRouter();
    app_router.on('login', function() {
      // Call render on the module we loaded in via the dependency array
      // 'views/projects/list'
      var loginView = new LoginRegistrationView();
      loginView.render();
    });
    Backbone.history.start();
  };
  return {
    initialize: initialize
  };
});
