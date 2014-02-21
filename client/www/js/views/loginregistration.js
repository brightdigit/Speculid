// Filename: views/project/list
define([
  'jquery',
  'marionette',
  'templates',
  'models/session',
  'models/registration',
  'store',
  'application',
  '../configuration',
  '../lib/names',
  'bootstrap',
  'jquery.validation',
  'jQuery.serializeObject'
  // Using the Require.js text! plugin, we are loaded raw text
  // which will be used as our views primary template
], function($, Marionette, templates, SessionModel, RegistrationModel, store, application, configuration, names) {
  var LoginRegistrationView = Marionette.ItemView.extend({
    template: templates.loginregistration,
    ui: {
      'cancelButton': '#cancel',
      'inputs': 'input',
      'registrationInputs': '.signup input',
      'registrationRows': '.signup',
      'buttons': 'button:not(.hide)',
      'form': 'form',
      'confirm_hide': '.confirm-hide',
      'confirmationButton': '#confirmation',
      'confirmationRows': '.confirmation',
      'debug': '#debug'
    },
    events: {
      "click #register": 'click',
      "click #login": 'click',
      "click #debug button": 'debug',
      "click #cancel": 'cancel'
    },
    cancel: function(evt) {
      this.xhr.abort();
      this.xhr = undefined;
    },
    debug: function(evt) {
      function _(attrName) {
        switch (attrName) {
          case 'name':
            var name = names();
            name = name[0].toLowerCase() + "-" + name[1].toLowerCase();
            if (name.length > 15) {
              name = name.substr(0, 12) + "-" + Math.floor(Math.random() * 100);
            }
            return name;
          case 'password':
          case 'confirm-password':
            return 'testtest';
          case 'emailAddress':
            return "test+" + Math.floor(Math.random() * 100000) + "@brightdigit.com";
        }
      }
      $.each(this.ui.inputs, function() {
        var $el = $(this);
        var value = _($el.attr('name'));
        if (value !== undefined) {
          $el.val(value);
        }
      });
    },
    click: function(evt) {
      var submitButton = this.ui.buttons.filter('[type="submit"]');
      var switchButton = this.ui.buttons.not('[type="submit"]');
      if (evt.target === switchButton[0]) {
        switchButton.toggleClass('btn-primary', true);
        submitButton.toggleClass('btn-primary', false);
        switchButton.attr('type', 'submit');
        submitButton.attr('type', 'button');
        this.ui.inputs.popover('destroy');
        this.ui.registrationInputs.toggleClass('ignore');
        this.ui.registrationRows.collapse('toggle');
        evt.preventDefault();
      }
    },

    submitRegistration: function(form) {
      console.log('submitRegistration');
      var data = $(form).serializeObject();
      console.log(data);
      store.set('user', data.name);
      store.set('password', data.password);
      this.model = new RegistrationModel({
        apiKey: data.apiKey,
        emailAddress: data.emailAddress
      });
      this.ui.buttons.filter('#login').fadeOut(
        function() {
          $(form).find('#cancel').removeClass('hide').fadeIn();
        }
      );
      this.ui.buttons.filter('#register').button('loading');
      this.xhr = this.model.save({}, {
        success: this.registrationSuccess.bind(this),
        error: this.registrationFailure.bind(this)
      });
      this.ui.inputs.not('.confirmation input').prop('readOnly', true);
    },
    registrationSuccess: function(data) {
      console.log('success:');
      console.log(data);
      this.ui.confirm_hide.collapse('hide');
      this.ui.confirmationRows.collapse('show');
      this.ui.buttons.fadeOut(function() {
        $('#confirmation').removeClass('hide').fadeIn();
      });
    },
    registrationFailure: function(data, xhr) {
      var that = this;
      console.log('failure:');
      console.log(xhr.statusText);
      if (xhr.statusText === "abort") {
        this.ui.cancelButton.fadeOut(function() {
          that.ui.buttons.filter('#login').fadeIn();
        });
        this.ui.buttons.filter('#register').button('reset');
        this.ui.inputs.not('.confirmation input').prop('readOnly', false);
      }
      console.log(data);
    },
    submitLogin: function(form) {
      console.log('login');
      var data = $(form).serializeObject();
      console.log(data);
    },
    loginSuccess: function(data) {
      console.log('success:');
      console.log(data);
    },
    loginFailure: function(data) {
      console.log('failure:');
      console.log(data);
    },
    onRender: function() {
      if (configuration.stage === 'development') {
        this.ui.debug.html("<button type=\"button\" class=\"btn btn-link\">Test</button>");
      } else {
        this.ui.debug.remove();
      }

      var view = this;
      this.validator = this.ui.form.validate({
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
            _popover.data("bs.popover").options.content = value.message;
            var popover = $(value.element).popover("show");
            return popover;
          });
        }
      });
    },
  });
  // Our module now returns our view
  return LoginRegistrationView;
});
