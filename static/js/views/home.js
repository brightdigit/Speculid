define(['backbone.marionette', 'templates', 'backbone', 'bootstrap', 'jquery'], function (Marionette, templates, Backbone, $) {
  return Backbone.Marionette.ItemView.extend({
    template: templates.home,
  });
});