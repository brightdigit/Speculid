define([
  'jquery',
  'backbone',
  'store',
  'views/loginregistration',
  'views/home',
  'views/registrationconfirmation'
], function($, Backbone, store, LoginRegistrationView, HomeView, RegistrationConfirmationView) {
  var AppRouter = Backbone.Router.extend({
    routes: {
      // Define some URL routes
      "": 'home',
      "/": 'home',
      "home": 'home',

      '/login': 'login',

      // Default
      '*actions': 'home',
      'registration-confirmation': 'registration-confirmation'
    }
  });

  var initialize = function() {
    var app_router = new AppRouter();
    app_router.on('route:login', function() {
      // Call render on the module we loaded in via the dependency array
      // 'views/projects/list'
      var loginView = new LoginRegistrationView();
      loginView.render();
    });
    app_router.on('route:home', function() {
      if (store.get("sessionKey")) {
        var homeView = new HomeView();
        homeView.render();
      } else {
        var loginView = new LoginRegistrationView();
        loginView.render();
      }
    });
    app_router.on('route:registration-confirmation', function() {
      // Call render on the module we loaded in via the dependency array
      // 'views/projects/list'
      var confirmationView = new RegistrationConfirmationView();
      confirmationView.render();
    });
    Backbone.history.start();
  };
  return {
    initialize: initialize
  };
});
