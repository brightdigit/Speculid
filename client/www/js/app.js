define(['marionette', 'views/loginregistration'], function(Marionette, LoginRegistrationView) {
  var Application = new Marionette.Application();
  Application.addRegions({
    main: "main"
  });
  Application.addInitializer(function(options) {
    Application.main.show(new LoginRegistrationView());
  });
  Application.vent.on('registration:success', function() {
    console.log('registration:success');
  });
  return Application;
});
