const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const authMiddleware = require('../middleware/auth');

router.get('/search', userController.searchUsers);
router.get('/:v_id', userController.getProfile);
router.put('/:v_id', authMiddleware, userController.updateProfile);

module.exports = router;
