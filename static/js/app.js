define(["backbone.marionette", "./router", 'views/home'], function (Marionette, Router, HomeView) {
  var app = new Marionette.Application();

  var Controller = Marionette.Controller.extend({

    initialize: function (options) {
      this.stuff = options.stuff;
    },

    index: function () {
      app.mainRegion.show(new HomeView({

      }));
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

  app.addInitializer(function () {
    new Router({
      controller: new Controller()
    });
    Backbone.history.start();
  });

  return app;
});