// Filename: views/project/list
define([
  'jquery',
  'backbone',
  // Using the Require.js text! plugin, we are loaded raw text
  // which will be used as our views primary template
], function($, Backbone) {
  var ProjectListView = Backbone.View.extend({
    el: $('h2'),
    render: function() {
      // Using Underscore we can compile our template with data
      // Append our compiled template to this Views "el"
      this.$el.append("test");
    }
  });
  // Our module now returns our view
  return ProjectListView;
});
