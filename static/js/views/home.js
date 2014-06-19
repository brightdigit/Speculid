define(['backbone.marionette', 'templates', 'backbone', 'jquery', 'bootstrap'], function (Marionette, templates, Backbone, $) {
  return Backbone.Marionette.ItemView.extend({
    template: templates.home,
    events: {
      "click button": "buttonClick",
      "click #register.btn-primary": "register",
      "click #signin.btn-primary": "signin"
    },
    ui: {
      signupSection: "#singup",
      buttons: "buttons"
    },
    register: function () {
      Backbone.history.navigate('#confirmation', {
        trigger: true
      });
    },
    signin: function () {
      Backbone.history.navigate('#home', {
        trigger: true
      });
    },
    buttonClick: function (event) {
      var id = $(event.target).attr('id');
      if (id === 'register') {
        $('#signup').collapse('show');
        $('button').removeClass('btn-primary');
        $(event.target).addClass('btn-primary');
      } else if (id === 'signin') {
        $('#signup').collapse('hide');
        $('button').removeClass('btn-primary');
        $(event.target).addClass('btn-primary');
      }
    }
  });
});