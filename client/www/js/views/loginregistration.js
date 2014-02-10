// Filename: views/project/list
define([
  'jquery',
  'backbone',
  'templates',
  // Using the Require.js text! plugin, we are loaded raw text
  // which will be used as our views primary template
], function($, Backbone, templates) {
  var ProjectListView = Backbone.View.extend({
    el: $('body > .container'),
    events: {
      "click [name='name']": 'loginFocus',
      "click [name='password']": 'loginFocus',
      "click [name='emailAddress']": 'signupFocus',
    },
    loginFocus: function() {
      this.$('#login').prop("disabled", false);
      this.$('#signup').prop("disabled", true);
      this.$('[name="name"]').prop("readonly", false);
      this.$('[name="emailAddress"]').prop("readonly", true);
      this.$('[name="password"]').prop("readonly", false);
    },
    signupFocus: function() {
      this.$('#login').prop("disabled", true);
      this.$('#signup').prop("disabled", false);
      this.$('[name="name"]').prop("readonly", true);
      this.$('[name="emailAddress"]').prop("readonly", false);
      this.$('[name="password"]').prop("readonly", true);
    },
    render: function() {
      // Using Underscore we can compile our template with data
      // Append our compiled template to this Views "el"
      this.$el.prepend(templates.loginregistration({}));
    }
  });
  // Our module now returns our view
  return ProjectListView;
});
