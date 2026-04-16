const express = require('express');
const router = express.Router();
const storyController = require('../controllers/storyController');
const authMiddleware = require('../middleware/auth');

router.get('/', storyController.getStories);
router.post('/', authMiddleware, storyController.createStory);
router.post('/:s_id/reaction', authMiddleware, storyController.addStoryReaction);

module.exports = router;
