define(['backbone.marionette', 'templates', 'backbone', 'jquery', '../models/registration', 'bootstrap', 'jQuery.serializeObject'], function (Marionette, templates, Backbone, $, RegistrationModel) {
  return Marionette.ItemView.extend({
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
      signupSection: "#signup",
      buttons: "button",
      form: "form"
    },
    register: function () {
/*
      Backbone.history.navigate('#confirmation', {
        trigger: true
      });
      */
      this.model = new RegistrationModel();
      this.model.save(this.ui.form.serializeObject(), {
        error: function () {
          console.log(arguments);
        },
        success: this.trigger.bind(this, "registration:post")
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
        this.ui.signupSection.collapse('show');
        //$('#signup').collapse('show');
        this.ui.buttons.removeClass('btn-primary');
        //$('button').removeClass('btn-primary');
        $(event.target).addClass('btn-primary');
      } else if (id === 'signin') {
        //$('#signup').collapse('hide');
        //$('button').removeClass('btn-primary');
        this.ui.signupSection.collapse('hide');
        //$('#signup').collapse('show');
        this.ui.buttons.removeClass('btn-primary');
        $(event.target).addClass('btn-primary');
      }
    }
  });
});