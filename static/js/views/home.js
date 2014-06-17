define(['backbone.marionette', 'templates'], function (Marionette, templates) {
  return Backbone.Marionette.ItemView.extend({
    template: templates.home
  });
});