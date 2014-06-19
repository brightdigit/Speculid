require.config({
  paths: {
    "templates": "../../.tmp/jst",
    "models/Account": "../../test/static/models/Account"
  },
  shim: {
    bootstrap: ['jquery']
  }
});