// Filename: views/project/list
define([
  'jquery',
  'marionette',
  'templates',
  'models/session',
  'models/registration',
  'store',
  'application',
  'bootstrap',
  'jquery.validation',
  'jQuery.serializeObject'
  // Using the Require.js text! plugin, we are loaded raw text
  // which will be used as our views primary template
], function($, Marionette, templates, SessionModel, RegistrationModel, store, application) {
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
      'confirmationRows': '.confirmation'
    },
    //el: $('body > .container'),
    events: {
      "click #register": 'click',
      "click #login": 'click',
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
      this.model.save({}, {
        success: this.registrationSuccess.bind(this),
        error: this.registrationFailure.bind(this)
      });
    },
    registrationSuccess: function(data) {
      console.log('success:');
      console.log(data);
      //application().vent.trigger('registration:success');
      this.ui.confirm_hide.collapse('hide');
      //this.ui.registrationRows.collapse('hide');
      this.ui.confirmationRows.collapse('show');
      this.ui.buttons.fadeOut(function() {
        $('#confirmation').removeClass('hide').fadeIn();
        $('input').not('.confirmation input').prop('readOnly', true);
      });
      /*
      var offset = this.ui.confirmationButton.offset();
      this.ui.confirmationButton.css('position', 'absolute');
      this.ui.confirmationButton.offset(offset);
      this.ui.confirmationButton.fadeIn(function() {
        $(this).css('position', '');
      });
*/
    },
    registrationFailure: function(data) {
      console.log('failure:');
      console.log(data);
    },
    submitLogin: function(form) {
      console.log('login');
      var data = $(form).serializeObject();
      console.log(data);
      /*
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
*/
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
      // manipulate the `el` here. it's already
      // been rendered, and is full of the view's
      // HTML, ready to go.
      var view = this;
      // Using Underscore we can compile our template with data
      // Append our compiled template to this Views "el"
      //this.$el.prepend(templates.loginregistration({}));
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
            // Bootstrap 3:
            _popover.data("bs.popover").options.content = value.message;
            // Bootstrap 2.x:
            //_popover.data("popover").options.content = value.message;
            var popover = $(value.element).popover("show");
            return popover;
          });
        }
      });
    },
    /*
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
    }*/
  });
  // Our module now returns our view
  return LoginRegistrationView;
});
