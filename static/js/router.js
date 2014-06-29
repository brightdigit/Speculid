define(['backbone.marionette'], function (Marionette) {
  return Marionette.AppRouter.extend({
    //"index" must be a method in AppRouter's controller
    appRoutes: {
      "": "index",
      "confirmation": "confirmation",
      "home": "home"
    }
  });
});