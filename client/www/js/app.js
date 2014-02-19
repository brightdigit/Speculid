define(['marionette', 'views/loginregistration', 'views/registrationconfirmation'],
  function(Marionette, LoginRegistrationView, RegistrationConfirmationView) {
    var Application = new Marionette.Application();
    Application.addRegions({
      main: "main"
    });
    Application.addInitializer(function(options) {
      Application.main.show(new LoginRegistrationView());
    });
    Application.vent.on('registration:success', function() {
      Application.main.show(new RegistrationConfirmationView());
    });
    return Application;
  });
