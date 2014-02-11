require(['jquery', 'moment', 'app', 'json!../../../tmp/build', 'json!../../../package.json', 'bootstrap', 'font!google,families:[Lato:300,Raleway]'],
  function($, moment, App, buildUTC, package) {
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
    $('#build-version').html('v' + package.version + "[" + moment(buildUTC).format("YY.MM.DD.HH.mm") + "]");
    App.initialize();
  });
