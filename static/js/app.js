define(["backbone.marionette", "./router", 'views/home'], function (Marionette, Router, HomeView) {
  var app = new Marionette.Application();

  var Controller = Marionette.Controller.extend({

    initialize: function (options) {
      this.stuff = options.stuff;
    },

    index: function () {
      var view;
      app.mainRegion.show(view = new HomeView({

      }));
      view.on("registration:post", function () {
        console.log('registration');
      });
    },

    home: function () {
      console.log('home');

    },

    cofirmation: function () {
      console.log('confirmation');
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