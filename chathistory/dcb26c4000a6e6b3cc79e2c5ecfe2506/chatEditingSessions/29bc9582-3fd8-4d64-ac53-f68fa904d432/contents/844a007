const express = require('express');
const router = express.Router();
const postController = require('../controllers/postController');
const authMiddleware = require('../middleware/auth');

router.get('/feed', postController.getFeed);
router.get('/:p_id', postController.getPost);
router.post('/', authMiddleware, postController.createPost);
router.delete('/:p_id', authMiddleware, postController.deletePost);

module.exports = router;
