define(['backbone.marionette', 'templates', 'backbone', 'jquery', '../models/registration'], function (Marionette, templates, Backbone, $, RegistrationModel) {
  return Backbone.Marionette.ItemView.extend({
    template: templates.login,
    events: {
      "click button": "buttonClick",
      "click #register.btn-primary": "register",
      "click #signin.btn-primary": "signin"
    },
    triggers: {
      //"click #register.btn-primary": "registration:post",
      //"click #signin.btn-primary": "session:post"
    },
    ui: {
      signupSection: "#singup",
      buttons: ".button",
      form: "form"
    },
    register: function () {
/*
      Backbone.history.navigate('#confirmation', {
        trigger: true
      });
      */
      this.model = new RegistrationModel(this.ui.form.serializeObject());
      this.trigger("registration:post");
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