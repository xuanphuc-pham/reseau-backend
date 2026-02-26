const express = require('express');
const { authenticate } = require('../middleware/authenticate');
const { requirePermission } = require('../middleware/authorize');
const { validate, validateId, REACTION_TYPES } = require('../middleware/validate');
const discussionController = require('../controllers/discussionController');

const router = express.Router();

const commentRouter = require('./comments');

// Montage des sous-routes commentaires: /discussions/:discussionId/comments
router.use('/:discussionId/comments', validateId('discussionId'), commentRouter);

// DISCUSSIONS

router.get('/', discussionController.list);

router.get('/:id', validateId('id'), discussionController.getById);

router.post('/',
  authenticate,
  requirePermission('discussion.create'),
  validate({
    title: { required: true, type: 'string', minLength: 1, maxLength: 200 },
    content: { required: true, type: 'string', minLength: 1, maxLength: 10000 },
  }),
  discussionController.create
);

router.patch('/:id',
  validateId('id'),
  authenticate,
  requirePermission('discussion.edit.own', 'discussion.edit.any'),
  validate({
    title: { type: 'string', maxLength: 200 },
    content: { type: 'string', maxLength: 10000 },
  }),
  discussionController.update
);

router.delete('/:id',
  validateId('id'),
  authenticate,
  requirePermission('discussion.delete.own', 'discussion.delete.any'),
  discussionController.remove
);


// RÉACTIONS DE DISCUSSION

router.post('/:id/reactions',
  validateId('id'),
  authenticate,
  requirePermission('reaction.create'),
  validate({
    type: { required: true, type: 'string', enum: REACTION_TYPES },
  }),
  discussionController.addReaction
);

router.delete('/:id/reactions',
  validateId('id'),
  authenticate,
  requirePermission('reaction.delete.own'),
  discussionController.removeReaction
);

module.exports = router;
