module.exports = function(sequelize, DataTypes) {
  var Entry = sequelize.$('entry'),
    Item = sequelize.$('item'),
    Session = sequelize.$('session');

  var Tag = sequelize.define("tag", {});

  Tag.belongsTo(Item);
  Tag.belongsTo(Entry);
  Tag.belongsTo(Session);

  return Tag;
};
