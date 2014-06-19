require.config({
  baseUrl: '../../static/js'
/*,
  paths: {
    'jquery'        : '/app/libs/jquery',
    'underscore'    : '/app/libs/underscore',
    'backbone'      : '/app/libs/backbone',
    'mocha'         : 'libs/mocha',
    'chai'          : 'libs/chai',
    'chai-jquery'   : 'libs/chai-jquery',
    'models'        : '/app/models'
  },
  shim: {
    'underscore': {
      exports: '_'
    },
    'jquery': {
      exports: '$'
    },
    'backbone': {
      deps: ['underscore', 'jquery'],
      exports: 'Backbone'
    },
    'chai-jquery': ['jquery', 'chai']
  },
  urlArgs: 'bust=' + (new Date()).getTime()
  */
});

require(['../../bower_components/chai/chai', '../../bower_components/mocha/mocha'], function (chai) {

  // Chai
  var should = chai.should();
  //  chai.use(chaiJquery);
  /*globals mocha */
  mocha.setup('bdd');

  describe('Models', function () {

    describe('Sample Model', function () {
      it('should default "urlRoot" property to "/api/samples"', function () {
        return true.should.be.ok;
      });
    });

  });

  mocha.run();
/*
  require([
    'specs/model-test.js',
  ], function(require) {
    mocha.run();
  });
 */
});