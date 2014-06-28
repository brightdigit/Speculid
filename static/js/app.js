define(["backbone.marionette", "./router", 'views/login', 'views/confirmation'], function (Marionette, Router, LoginView, ConfirmationView) {
  var app = new Marionette.Application();

  var Controller = Marionette.Controller.extend({

    initialize: function (options) {
      this.stuff = options.stuff;
    },

    index: function () {
      var view;
      app.mainRegion.show(view = new LoginView({

      }));
      view.on("registration:post", function () {
        console.log('registration');
        console.log(arguments);

        Backbone.history.navigate('#confirmation', {
          trigger: false
        });
        var view;
        app.mainRegion.show(view = new ConfirmationView({

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