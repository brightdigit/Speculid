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
      "click #register": 'click',
      "click #login": 'click',
    },
    click: function(evt) {
      var buttons = this.$('button');
      var submitButton = buttons.filter('[type="submit"]');
      var switchButton = buttons.not('[type="submit"]');
      if (evt.target === switchButton[0]) {
        switchButton.toggleClass('btn-primary', true);
        submitButton.toggleClass('btn-primary', false);
        switchButton.attr('type', 'submit');
        submitButton.attr('type', 'button');
        this.$('input').popover('destroy');
        this.$('.collapse,.in input').toggleClass('ignore');
        this.$('.in,.collapse').collapse('toggle');
        evt.preventDefault();
      }
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
      this.model.save({}, {
        success: this.registrationSuccess.bind(this),
        error: this.registrationFailure.bind(this)
      });
    },
    registrationSuccess: function(data) {
      console.log('success:');
      console.log(data);
    },
    registrationFailure: function(data) {
      console.log('failure:');
      console.log(data);
    },
    submitLogin: function(form) {
      var data = $(form).serializeObject();
      console.log(data);
      var deviceKey = store.get('deviceKey');
      store.set('user', data.name);
      store.set('password', data.password);
      this.model = new SessionModel({
        name: data.name,
        password: data.password,
        apiKey: data.apiKey
      });
      if (deviceKey) {
        this.model.set('deviceKey', deviceKey);
      }
      this.model.save({}, {
        success: this.loginSuccess.bind(this),
        error: this.loginFailure.bind(this)
      });
    },
    loginSuccess: function(data) {
      console.log('success:');
      console.log(data);
    },
    loginFailure: function(data) {
      console.log('failure:');
      console.log(data);
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
          var type = $(form).find('[type="submit"]').attr('id');
          if (type === 'register') {
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
