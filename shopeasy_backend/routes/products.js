const express = require('express');
const router = express.Router();
const { Product, Category, Review, User } = require('../models');
const { protect } = require('../middleware/authMiddleware');

// Get all products (optionally filter by category)
router.get('/', async (req, res) => {
  try {
    const { category, categoryId } = req.query;
    const cid = category || categoryId;
    const where = cid ? { CategoryId: cid } : {};
    const products = await Product.findAll({
      where,
      include: [{ model: Category, attributes: ['title'] }],
    });
    res.json({ products });
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

// Get reviews for a product
router.get('/:id/reviews', async (req, res) => {
  try {
    const reviews = await Review.findAll({
      where: { ProductId: req.params.id },
      include: [{ model: User, attributes: ['firstName', 'lastName'] }],
      order: [['createdAt', 'DESC']],
    });
    res.json({ reviews });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Add a review for a product
router.post('/:id/reviews', protect, async (req, res) => {
  try {
    const { comment, rating } = req.body;
    const review = await Review.create({
      comment,
      rating,
      ProductId: req.params.id,
      UserId: req.user.id,
    });
    res.status(201).json(review);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;