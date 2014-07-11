define(['backbone.marionette', 'templates', 'backbone', 'jquery', 'bootstrap'], function (Marionette, templates, Backbone, $) {
  return Backbone.Marionette.ItemView.extend({
    template: templates.confirmation
  });
});