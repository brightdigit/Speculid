require(['jquery', 'app', 'bootstrap', 'jquery.validate', 'font!google,families:[Lato:300,Raleway]'], function($, App) {
  /*
  $.validator.addMethod(
        "regex",
        function(value, element, regexp) {
            var re = new RegExp(regexp);
            return this.optional(element) || re.test(value);
        },
        "Please check your input."
);
  */
  App.initialize();
});
