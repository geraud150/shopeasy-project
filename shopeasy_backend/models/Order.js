const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Order = sequelize.define('Order', {
  status: {
    type: DataTypes.STRING,
    defaultValue: 'pending',
  },
  totalAmount: {
    type: DataTypes.FLOAT,
  },
});

module.exports = Order;
