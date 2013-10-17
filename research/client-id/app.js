var express = require('express'),
  Sequelize = require('sequelize'),
  app = express();

var sequelize = new Sequelize('database', null, null, {
  // sqlite! now!
  dialect: 'sqlite',

  // the storage engine for sqlite
  // - default ':memory:'
  storage: 'database.sqlite'
});

var Entry = sequelize.define("entry", {
  name : {
    type : Sequelize.STRING,
    allowNull : false
  }
});

var Field = sequelize.define("field", {
  name : {
    type : Sequelize.STRING,
    allowNull : false,
    unique : true
  }
});

var Header = sequelize.define("header", {
  value : {
    type : Sequelize.STRING,
    allowNull : false
  }
});

Header.belongsTo(Field).belongsTo(Entry);

sequelize.sync().success( function () {
  app.get('/:name', function(req, res){
    var chainer = new Sequelize.Utils.QueryChainer();
    chainer
      .add(Entry.create({name : req.params.name}));
    for (var key in req.headers) {
      chainer.add(Field.findOrCreate({name : key}));
    }

    chainer.run().success(function (results) {

      var entry = results[0];

      for (var index = 1; index < results.length; index++) {
        var field = results[index];
        Header.create({
            value : req.headers[field.name]
        }).success(function (header) {
          header.setEntry(entry).success( function (header) {
            header.setField(field).success(function (header) {

            });
          });
        });//.setEntry(entry).setField(results[index]));
      }
      res.send(entry.id);

    });

  });

  app.listen(3000);
}).error(function (error) {
  console.log(error);
});
