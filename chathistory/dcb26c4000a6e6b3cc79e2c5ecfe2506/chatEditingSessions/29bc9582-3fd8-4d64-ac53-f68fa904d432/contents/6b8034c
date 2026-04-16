const express = require('express');
const router = express.Router();
const soundController = require('../controllers/soundController');
const authMiddleware = require('../middleware/auth');

router.get('/', soundController.getAllSounds);
router.get('/user/:v_id', soundController.getUserSounds);
router.post('/', authMiddleware, soundController.createSound);

module.exports = router;
