requirejs.config({
  shim: {
    underscore: {
      exports: '_'
    },
    'jquery.validation': [
      'jquery'
    ],
    'jQuery.serializeObject': [
      'jquery'
    ]
  },
  paths: {
    bootstrap: '../../../bower_components/bootstrap/dist/js/bootstrap',
    jquery: '../../../bower_components/jquery/dist/jquery',
    requirejs: '../../../bower_components/requirejs/require',
    async: '../../../bower_components/requirejs-plugins/src/async',
    font: '../../../bower_components/requirejs-plugins/src/font',
    goog: '../../../bower_components/requirejs-plugins/src/goog',
    image: '../../../bower_components/requirejs-plugins/src/image',
    json: '../../../bower_components/requirejs-plugins/src/json',
    noext: '../../../bower_components/requirejs-plugins/src/noext',
    mdown: '../../../bower_components/requirejs-plugins/src/mdown',
    propertyParser: '../../../bower_components/requirejs-plugins/src/propertyParser',
    markdownConverter: '../../../bower_components/requirejs-plugins/lib/Markdown.Converter',
    depend: '../../../bower_components/requirejs-plugins/src/depend',
    'Markdown.Converter': '../../../bower_components/requirejs-plugins/lib/Markdown.Converter',
    text: '../../../bower_components/requirejs-plugins/lib/text',
    backbone: '../../../bower_components/backbone/backbone',
    underscore: '../../../bower_components/underscore/underscore',
    templates: '../../../tmp/templates',
    store: '../../../bower_components/store.js/store',
    buildUTC: 'json!../../../tmp/build',
    'backbone.wreqr': '../../../bower_components/backbone.wreqr/lib/amd/backbone.wreqr',
    'backbone.babysitter': '../../../bower_components/backbone.babysitter/lib/amd/backbone.babysitter',
    'jquery.validation': '../../../bower_components/jquery.validation/jquery.validate',
    moment: '../../../bower_components/moment/moment',
    'jQuery.serializeObject': '../../../bower_components/jQuery.serializeObject/jQuery.serializeObject',
    marionette: '../../../bower_components/marionette/lib/core/amd/backbone.marionette',
    'backbone.marionette': '../../../bower_components/marionette/lib/core/amd/backbone.marionette',
    application: 'application',
    sizzle: '../../../bower_components/sizzle/dist/sizzle'
  }
});
