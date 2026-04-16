const express = require('express');
const router = express.Router();
const followController = require('../controllers/followController');
const authMiddleware = require('../middleware/auth');

router.get('/:v_id/followers', followController.getFollowers);
router.get('/:v_id/following', followController.getFollowing);
router.get('/:target_id/is-following', authMiddleware, followController.isFollowing);
router.post('/:followee_id/follow', authMiddleware, followController.followUser);
router.delete('/:followee_id/unfollow', authMiddleware, followController.unfollowUser);

module.exports = router;
