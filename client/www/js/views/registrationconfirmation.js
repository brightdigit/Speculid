// Filename: views/project/list
define([
  'jquery',
  'backbone',
  'templates',
  // Using the Require.js text! plugin, we are loaded raw text
  // which will be used as our views primary template
], function($, Backbone, templates) {
  var RegistrationConfirmationView = Backbone.View.extend({
    el: $('body > .container'),
    events: {
      //"blur input": 'inputBlur',
    },
    render: function() {
      var view = this;
      // Using Underscore we can compile our template with data
      // Append our compiled template to this Views "el"
      this.$el.prepend(templates.registrationconfirmation({}));
      this.validator = this.$('form').validate({

      });
    }
  });
  // Our module now returns our view
  return RegistrationConfirmationView;
});
