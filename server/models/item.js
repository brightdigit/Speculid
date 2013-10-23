module.exports = function(sequelize, DataTypes) {
  var Item = sequelize.define("item", {
    name: {
      type: DataTypes.STRING(250),
      allowNull: false,
      unique: true,
      validate: {
        is: ["[a-z][a-z0-9-]{4,14}"]
      }
    }
  });

  return Item;
};
