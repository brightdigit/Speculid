define(['marionette', 'moment', '../configuration'], function(Marionette, moment, configuration) {
  var BuildVersionView = Marionette.ItemView.extend({
    render: function() {
      this.$el.html('<strong>' + configuration.package.prerelease + '</strong> v' + configuration.package.version + "[" + moment(configuration.build).format("YY.MM.DD.HH.mm") + "]");
    }
  });

  return BuildVersionView;
});
