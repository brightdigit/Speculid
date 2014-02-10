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
    render: function() {
      // Using Underscore we can compile our template with data
      // Append our compiled template to this Views "el"
      this.$el.prepend(templates.loginregistration({}));
    }
  });
  // Our module now returns our view
  return ProjectListView;
});
