const express = require('express');
const router = express.Router();
const { Order, OrderItem, Product } = require('../models');
const { protect } = require('../middleware/authMiddleware');
const sequelize = require('../config/database');

// Get user orders
router.get('/', protect, async (req, res) => {
  try {
    const orders = await Order.findAll({
      where: { UserId: req.user.id },
      include: [
        {
          model: OrderItem,
        },
      ],
      order: [['createdAt', 'DESC']],
    });

    res.json({ orders: orders });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create a new order
router.post('/', protect, async (req, res) => {
  const { items, address, totalAmount: clientTotalAmount } = req.body;

  const t = await sequelize.transaction();

  try {
    let totalAmount = 0;
    for (const item of items) {
      const product = await Product.findByPk(item.productId, { transaction: t });
      if (!product || product.quantityInStock < item.quantity) {
        throw new Error(`Product ${product ? product.title : item.productId} is out of stock or does not exist.`);
      }
      totalAmount += product.price * item.quantity;
    }

    const order = await Order.create(
      {
        UserId: req.user.id,
        totalAmount,
        street: address.street,
        city: address.city,
        zipCode: address.zipCode,
        country: address.country,
      },
      { transaction: t }
    );

    for (const item of items) {
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