const sequelize = require('../config/database');
const User = require('./User');
const Product = require('./Product');
const Category = require('./Category');
const StockMovement = require('./StockMovement');
const Order = require('./Order');
const OrderItem = require('./OrderItem');
const LoginHistory = require('./LoginHistory');
const Review = require('./Review');

// User -> Category (One-to-Many)
User.hasMany(Category);
Category.belongsTo(User);

// Category -> Product (One-to-Many)
Category.hasMany(Product);
Product.belongsTo(Category);

// Product -> StockMovement (One-to-Many)
Product.hasMany(StockMovement);
StockMovement.belongsTo(Product);

// User -> Order (One-to-Many)
User.hasMany(Order);
Order.belongsTo(User);

// Order -> OrderItem -> Product (Many-to-Many)
Order.belongsToMany(Product, { through: OrderItem });
Product.belongsToMany(Order, { through: OrderItem });

Order.hasMany(OrderItem);
OrderItem.belongsTo(Order);

Product.hasMany(OrderItem);
OrderItem.belongsTo(Product);

// User -> LoginHistory (One-to-Many)
User.hasMany(LoginHistory);
LoginHistory.belongsTo(User);

// Product -> Review (One-to-Many)
Product.hasMany(Review);
Review.belongsTo(Product);

// User -> Review (One-to-Many)
User.hasMany(Review);
Review.belongsTo(User);

const db = {
  sequelize,
  User,
  Product,
  Category,
  StockMovement,
  Order,
  OrderItem,
  LoginHistory,
  Review,
};

module.exports = db;