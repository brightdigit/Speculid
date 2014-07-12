requirejs.config({
  paths: {
    "templates": "../../.tmp/jst"
  },
  shim: {
    "bootstrap": {
      "deps": ['jquery']
    },
    "jQuery.serializeObject": {
      "deps": ['jquery']
    },
  }
});