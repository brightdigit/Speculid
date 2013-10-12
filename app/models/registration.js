module.exports = function(sequelize, DataTypes) {
  return sequelize.define("registration", {
    emailAddress: {
      type : DataTypes.STRING,
      allowNull : false,
      validate: {
        isEmail : true
      }
    },
    key: {
      type : DataTypes.BLOB('tiny'),
      allowNull : false
    },
    secret: {
      type : DataTypes.BLOB('tiny'),
      allowNull : false
    },
    registeredAt : {
      type: DataTypes.DATE,
      allowNull : false,
      defaultValue: DataTypes.NOW
    }
  });
};
