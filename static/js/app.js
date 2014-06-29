define(["backbone.marionette", "./router", 'views/login', 'views/confirmation', 'views/home', 'models/session'], function (Marionette, Router, LoginView, ConfirmationView, HomeView, SessionModel) {
  var app = new Marionette.Application();

  var Controller = Marionette.Controller.extend({

    initialize: function (options) {
      this.stuff = options.stuff;
    },

    index: function () {
      var view;
      app.mainRegion.show(view = new LoginView());
      view.on("registration:post", function () {

        Backbone.history.navigate('#confirmation', {
          trigger: false
        });
        var view;
        app.mainRegion.show(view = new ConfirmationView({

        }));
      });

      view.on("session:post", function () {

        Backbone.history.navigate('#home', {
          trigger: false
        });
        var view;
        app.mainRegion.show(view = new HomeView({
          model: new SessionModel({
            user: {
              name: "John"
            }
          })
        }));
      });
    },

    home: function () {
      console.log('home');
    },

    confirmation: function () {
      console.log('confirmation');
      var view;
      app.mainRegion.show(view = new ConfirmationView({

      }));
    }
  });

  app.addRegions({
    headerRegion: "header",
    mainRegion: "main"
  });

  app.on("registration:post", function () {
    console.log('registration');
  });

  app.addInitializer(function () {
    new Router({
      controller: new Controller()
    });
    Backbone.history.start();
  });

  return app;
});