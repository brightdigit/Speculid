define(['marionette', 'views/loginregistration', 'views/buildversion'],
  function(Marionette, LoginRegistrationView, BuildVersionView) {
    var Application = new Marionette.Application();
    Application.addRegions({
      main: "main",
      buildversion: "#build-version"
    });
    Application.addInitializer(function(options) {
      Application.main.show(new LoginRegistrationView());
      Application.buildversion.show(new BuildVersionView());
    });
    return Application;
  });
