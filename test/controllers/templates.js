var templates = proxyquire('../../app/controllers/templates.js', {
  lsr : function (path, callback, iterator) {
  },
  _ : {
    template : function (str) {
      return function (data) {

      };
    }
  },
  path : {
    extname : function (file) {

    },
    basename : function (file, ext) {
      
    }    
  },
  async : {
    each : function (arr, iterator, callback) {

    }
  }
});
