var Sequelize = require('sequelize');

var sequelize = new Sequelize('database', null, null, {
  // sqlite! now!
  dialect: 'sqlite',
  logging: false
});

var Entry = sequelize.define("entry", {
  value: {
    type: Sequelize.INTEGER,
    allowNull: false
  }
});

sequelize.sync().success(function () {

  var qc = new Sequelize.Utils.QueryChainer();

  for (var index = 0; index < 1000; index++) {
    qc.add(Entry.create({value : Math.floor(Math.random()*1000)}));
  }

  qc.run().success(function () {
    Entry.all().success(function (results) {
      console.log(results.map(function (i) {return i.dataValues.value;}));
    });
  });
});