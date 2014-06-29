requirejs.config({
  paths: {
    "templates": "../../.tmp/jst"
  },
  shim: {
    bootstrap: ['jquery'],
    "jQuery.serializeObject": ['jquery']
  }
});