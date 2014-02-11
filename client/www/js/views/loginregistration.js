// Filename: views/project/list
define([
  'jquery',
  'backbone',
  'templates',
  'models/session',
  'store',
  'jquery-validation',
  // Using the Require.js text! plugin, we are loaded raw text
  // which will be used as our views primary template
], function($, Backbone, templates, SessionModel) {
  var ProjectListView = Backbone.View.extend({
    el: $('body > .container'),
    events: {
      "blur input": 'inputBlur',
      "click #register": 'register',
      "click #login": 'login',
    },
    inputBlur: function() {},
    validate: function(callback) {
      this.$('form').validate({
        debug: true,
        /*rules: {
          name: {
            required: true
          },
          password: {
            required: true
          },
          confirmPassword: {
            required: this.isRegistration
          },
          emailAddress: {
            required: this.isRegistration
          }
        },*/
        showErrors: function(errorMap, errorList) {
          $.each(this.successList, function(index, value) {
            return $(value).popover("hide");
          });
          return $.each(errorList, function(index, value) {
            var _popover;
            _popover = $(value.element).popover({
              trigger: "manual",
              placement: "top",
              content: value.message,
              template: "<div class=\"popover\"><div class=\"arrow\"></div><div class=\"popover-inner\"><div class=\"popover-content\"><p></p></div></div></div>"
            });
            // Bootstrap 3:
            popover.data("bs.popover").options.content = value.message;
            // Bootstrap 2.x:
            //_popover.data("popover").options.content = value.message;
            return $(value.element).popover("show");
          });
        }
      });
    },
    register: function(evt) {
      if (this.isRegistration) {
        this.validate(function() {

        });
      } else {
        this.isRegistration = !this.isRegistration;
        this.$('.collapse').collapse('show');
        this.$('#register').toggleClass('btn-primary', true);
        this.$('#login').toggleClass('btn-primary', false);
      }

      evt.preventDefault();
    },
    login: function(evt) {
      if (!this.isRegistration) {
        this.validate(function() {

        });
      } else {
        this.isRegistration = !this.isRegistration;
        this.$('.in').collapse('hide');
        this.$('#register').toggleClass('btn-primary', false);
        this.$('#login').toggleClass('btn-primary', true);
      }

      evt.preventDefault();
    },
    render: function() {
      // Using Underscore we can compile our template with data
      // Append our compiled template to this Views "el"
      this.$el.prepend(templates.loginregistration({}));
    }
  });
  // Our module now returns our view
  return ProjectListView;
});
