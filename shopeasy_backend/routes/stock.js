const express = require('express');
const router = express.Router();
const { Product, StockMovement } = require('../models');
const { protect } = require('../middleware/authMiddleware');

// Record a stock movement
router.post('/', protect, async (req, res) => {
  try {
    const { productId, type, quantity } = req.body;

    const product = await Product.findByPk(productId);
    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }

    if (type === 'in') {
      product.quantityInStock += quantity;
    } else if (type === 'out') {
      if (product.quantityInStock < quantity) {
        return res.status(400).json({ error: 'Not enough stock' });
      }
      product.quantityInStock -= quantity;
    } else {
      return res.status(400).json({ error: 'Invalid movement type' });
    }

    await product.save();
    const movement = await StockMovement.create({
      ProductId: productId,
      type,
      quantity,
    });

    res.status(201).json({ product, movement });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;
