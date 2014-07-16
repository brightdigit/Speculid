define(['backbone.marionette', 'templates', 'backbone', 'jquery', '../models/registration', '../models/session', 'bootstrap', 'jQuery.serializeObject'], function (Marionette, templates, Backbone, $, RegistrationModel, SessionModel) {
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
      this.model = new RegistrationModel();
      this.model.save(this.ui.form.serializeObject(), {
        error: function () {
          console.log(arguments);
        },
        success: this.trigger.bind(this, "registration:post")
      });

    },
    signin: function () {
      this.model = new SessionModel();
      this.model.save(this.ui.form.serializeObject(), {
        error: function () {
          console.log(arguments);
        },
        success: this.trigger.bind(this, "session:post")
      });
    },
    buttonClick: function (event) {
      var target = $(event.target);
      var id = target.attr('id');
      if (target.hasClass('btn-primary')) {
        return;
      }
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