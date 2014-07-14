define(['module', 'backbone'], function (module, Backbone) {
  return Backbone.Model.extend({
    urlRoot: function () {
      return ["/api/v1", this.resource].join('/');
    },
    resource: undefined
  });
});