const express = require('express');
const router = express.Router();
const commentController = require('../controllers/commentController');
const authMiddleware = require('../middleware/auth');

router.get('/:p_id', commentController.getComments);
router.post('/:p_id', authMiddleware, commentController.addComment);
router.delete('/:comment_id', authMiddleware, commentController.deleteComment);

module.exports = router;
