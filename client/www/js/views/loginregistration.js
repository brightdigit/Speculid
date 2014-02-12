// Filename: views/project/list
define([
  'jquery',
  'backbone',
  'templates',
  'models/session',
  'models/registration',
  'store',
  'jquery-validation',
  'jQuery.serializeObject'
  // Using the Require.js text! plugin, we are loaded raw text
  // which will be used as our views primary template
], function($, Backbone, templates, SessionModel, RegistrationModel, store) {
  var ProjectListView = Backbone.View.extend({
    el: $('body > .container'),
    events: {
      "blur input": 'inputBlur',
      "click #register": 'register',
      "click #login": 'login',
    },
    inputBlur: function() {},
    validate: function(callback) {

    },
    register: function(evt) {
      if (!this.isRegistration) {
        this.isRegistration = !this.isRegistration;
        this.$('#register').toggleClass('btn-primary', true);
        this.$('#login').toggleClass('btn-primary', false);
        this.$('#register').attr('type', 'submit');
        this.$('#login').attr('type', 'button');
        this.$('input').popover('destroy');
        this.$('.collapse input').toggleClass('ignore');
        this.$('.collapse').collapse('show');
        evt.preventDefault();
      } else {
        //console.log(this.validator.form());
      }
      //evt.preventDefault();

    },
    login: function(evt) {
      if (this.isRegistration) {
        this.isRegistration = !this.isRegistration;
        this.$('#register').toggleClass('btn-primary', false);
        this.$('#login').toggleClass('btn-primary', true);
        this.$('#register').attr('type', 'button');
        this.$('#login').attr('type', 'submit');
        this.$('input').popover('destroy');
        this.$('.in input').toggleClass('ignore');
        this.$('.in').collapse('hide');
        evt.preventDefault();
      } else {
        //console.log(this.validator.form());
      }
      //evt.preventDefault();

    },
    registrationSuccess: function(data) {
      console.log(data);
    },
    registrationFailure: function(data) {

    },
    submitRegistration: function(form) {
      var data = $(form).serializeObject();
      console.log(data);
      store.set('user', data.name);
      store.set('password', data.password);
      this.model = new RegistrationModel({
        apiKey: data.apiKey,
        emailAddress: data.emailAddress
      });
      this.model.save();
    },
    submitLogin: function() {

    },
    render: function() {
      var view = this;
      // Using Underscore we can compile our template with data
      // Append our compiled template to this Views "el"
      this.$el.prepend(templates.loginregistration({}));
      this.validator = this.$('form').validate({
        ignore: '.ignore',
        onfocusout: false,
        onfocusin: false,
        onkeyup: false,
        submitHandler: function(form) {
          if ( !! view.isRegistration) {
            view.submitRegistration(form);
          } else {
            view.submitLogin(form);
          }
        },
        showErrors: function(errorMap, errorList) {
          $.each(this.successList, function(index, value) {
            return $(value).popover("hide");
          });
          return $.each(errorList, function(index, value) {
            var _popover;
            _popover = $(value.element).popover({
              trigger: "manual",
              placement: "right",
              content: value.message,
              template: "<div class=\"popover\"><div class=\"arrow\"></div><div class=\"popover-inner\"><div class=\"popover-content\"><p></p></div></div></div>",
              container: "body"
            });
            // Bootstrap 3:
            _popover.data("bs.popover").options.content = value.message;
            // Bootstrap 2.x:
            //_popover.data("popover").options.content = value.message;
            var popover = $(value.element).popover("show");
            return popover;
          });
        }
      });
    }
  });
  // Our module now returns our view
  return ProjectListView;
});
