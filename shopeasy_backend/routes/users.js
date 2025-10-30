const express = require('express');
const router = express.Router();
const { User, LoginHistory } = require('../models');
const { protect } = require('../middleware/authMiddleware');

// Get user profile
router.get('/me', protect, async (req, res) => {
  res.json(req.user);
});

// Update user profile
router.put('/me', protect, async (req, res) => {
  try {
    const { firstName, lastName, email } = req.body;
    const user = await User.findByPk(req.user.id);

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    user.firstName = firstName || user.firstName;
    user.lastName = lastName || user.lastName;
    user.email = email || user.email;

    await user.save();
    res.json(user);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Get user login history
router.get('/me/login-history', protect, async (req, res) => {
  try {
    const history = await LoginHistory.findAll({
      where: { UserId: req.user.id },
      order: [['createdAt', 'DESC']],
    });
    res.json(history);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
