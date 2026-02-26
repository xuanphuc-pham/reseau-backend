const express = require('express');

const authRoutes = require('./auth');
const userRoutes = require('./users');
const discussionRoutes = require('./discussions');

const router = express.Router();

router.get('/health', (req, res) => {
  res.json({ success: true, data: { status: 'ok' } });
});

router.use('/auth', authRoutes);

router.use('/users', userRoutes);


router.use('/discussions', discussionRoutes);

module.exports = router;
