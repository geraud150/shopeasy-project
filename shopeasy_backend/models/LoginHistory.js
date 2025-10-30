const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const LoginHistory = sequelize.define('LoginHistory', {
  ipAddress: {
    type: DataTypes.STRING,
  },
  device: {
    type: DataTypes.STRING,
  },
}, {
  updatedAt: false, // We only care about the creation date
});

module.exports = LoginHistory;
