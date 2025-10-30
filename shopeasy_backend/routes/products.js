const express = require('express');
const router = express.Router();
const { Product, Category } = require('../models');

// Get all products (optionally filter by category)
router.get('/', async (req, res) => {
  try {
    const { categoryId } = req.query;
    const where = categoryId ? { CategoryId: categoryId } : {};
    const products = await Product.findAll({
      where,
      include: [{ model: Category, attributes: ['title'] }],
    });
    res.json(products);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get a single product by ID
router.get('/:id', async (req, res) => {
  try {
    const product = await Product.findByPk(req.params.id, {
      include: [{ model: Category, attributes: ['title'] }],
    });
    if (!product) {
      return res.status(404).json({ error: 'Product not found' });
    }
    res.json(product);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
