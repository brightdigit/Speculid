requirejs.config({
  paths: {
    "templates": "../../.tmp/jst",
    "_": "../../bower_components/lodash/dist/lodash"
  },

  shim: {
    "zepto": {
      "exports": '$'
    }
  }
});