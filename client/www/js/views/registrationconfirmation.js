// Filename: views/project/list
define([
  'marionette',
  'templates'
  // Using the Require.js text! plugin, we are loaded raw text
  // which will be used as our views primary template
], function(Marionette, templates) {
  var RegistrationConfirmationView = Marionette.ItemView.extend({
    template: templates.registrationconfirm
  });
  // Our module now returns our view
  return RegistrationConfirmationView;
});
