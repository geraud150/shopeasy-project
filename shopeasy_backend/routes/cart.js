const express = require('express');
const router = express.Router();
const { Order, OrderItem, Product } = require('../models');
const { protect } = require('../middleware/authMiddleware');
const sequelize = require('../config/database');

// Validate cart and create order
router.post('/validate', protect, async (req, res) => {
  const { cartItems } = req.body; // Expects an array of { productId, quantity }

  const t = await sequelize.transaction();

  try {
    let totalAmount = 0;
    for (const item of cartItems) {
      const product = await Product.findByPk(item.productId, { transaction: t });
      if (!product || product.quantityInStock < item.quantity) {
        throw new Error(`Product ${product.title} is out of stock or does not exist.`);
      }
      totalAmount += product.price * item.quantity;
    }

    const order = await Order.create(
      { UserId: req.user.id, totalAmount },
      { transaction: t }
    );

    for (const item of cartItems) {
      const product = await Product.findByPk(item.productId, { transaction: t });
      await OrderItem.create(
        {
          OrderId: order.id,
          ProductId: item.productId,
          quantity: item.quantity,
          price: product.price,
        },
        { transaction: t }
      );

      product.quantityInStock -= item.quantity;
      await product.save({ transaction: t });
    }

    await t.commit();
    res.status(201).json({ message: 'Order created successfully', orderId: order.id });
  } catch (error) {
    await t.rollback();
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;
