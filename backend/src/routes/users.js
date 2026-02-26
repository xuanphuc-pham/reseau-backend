const express = require('express');
const { authenticate } = require('../middleware/authenticate');
const { requirePermission } = require('../middleware/authorize');
const { validate, validateId } = require('../middleware/validate');
const userController = require('../controllers/userController');

const router = express.Router();

// Route lié aux utilisateurs

router.get('/',
  authenticate,
  requirePermission('user.read.any'),
  userController.list
);

router.get('/me', authenticate, userController.getMe);

router.get('/:id',
  validateId('id'),
  authenticate,
  requirePermission('user.read.any', 'user.read.own'),
  userController.getById
);

router.patch('/:id',
  validateId('id'),
  authenticate,
  requirePermission('user.edit.own', 'user.edit.any'),
  validate({
    fname: { type: 'string', maxLength: 50 },
    lname: { type: 'string', maxLength: 50 },
    password: { type: 'string', minLength: 6, maxLength: 128 },
    current_password: { type: 'string' },
  }),
  userController.update
);

router.delete('/:id',
  validateId('id'),
  authenticate,
  requirePermission('user.delete.own', 'user.delete.any'),
  userController.remove
);

router.post('/:id/ban',
  validateId('id'),
  authenticate,
  requirePermission('user.ban.any'),
  userController.ban
);

router.post('/:id/unban',
  validateId('id'),
  authenticate,
  requirePermission('user.ban.any'),
  userController.unban
);

module.exports = router;
