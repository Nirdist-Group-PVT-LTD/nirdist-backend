const express = require('express');
const router = express.Router();
const reactionController = require('../controllers/reactionController');
const authMiddleware = require('../middleware/auth');

router.get('/:p_id', reactionController.getPostReactions);
router.post('/:p_id', authMiddleware, reactionController.addPostReaction);
router.delete('/:p_id', authMiddleware, reactionController.removeReaction);

module.exports = router;
