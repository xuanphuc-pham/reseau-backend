const express = require('express');
const { authenticate } = require('../middleware/authenticate');
const { requirePermission } = require('../middleware/authorize');
const { validate, validateId, REACTION_TYPES } = require('../middleware/validate');
const commentController = require('../controllers/commentController');

const router = express.Router({ mergeParams: true });

// =============================================
// COMMENTAIRES

router.get('/', commentController.list);

router.post('/',
  authenticate,
  requirePermission('comment.create'),
  validate({
    content: { required: true, type: 'string', minLength: 1, maxLength: 5000 },
  }),
  commentController.create
);

router.patch('/:commentId',
  validateId('commentId'),
  authenticate,
  requirePermission('comment.edit.own', 'comment.edit.any'),
  validate({
    content: { required: true, type: 'string', minLength: 1, maxLength: 5000 },
  }),
  commentController.update
);

router.delete('/:commentId',
  validateId('commentId'),
  authenticate,
  requirePermission('comment.delete.own', 'comment.delete.any'),
  commentController.remove
);

// =============================================
// RÉACTIONS DE COMMENTAIRE

router.post('/:commentId/reactions',
  validateId('commentId'),
  authenticate,
  requirePermission('reaction.create'),
  validate({
    type: { required: true, type: 'string', enum: REACTION_TYPES },
  }),
  commentController.addReaction
);

router.delete('/:commentId/reactions',
  validateId('commentId'),
  authenticate,
  requirePermission('reaction.delete.own'),
  commentController.removeReaction
);

module.exports = router;
