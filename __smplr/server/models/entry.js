module.exports = function(sequelize, DataTypes) {
  var Session = sequelize.$('session'),
    Item = sequelize.$('item');

  var Entry = sequelize.define("entry", {});

  Entry.belongsTo(Item);
  Entry.belongsTo(Session);

  return Entry;
};
