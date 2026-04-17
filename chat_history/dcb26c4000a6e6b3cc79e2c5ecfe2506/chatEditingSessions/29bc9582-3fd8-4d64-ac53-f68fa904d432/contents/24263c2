const express = require('express');
const router = express.Router();
const noteController = require('../controllers/noteController');
const authMiddleware = require('../middleware/auth');

router.get('/', noteController.getNotes);
router.post('/', authMiddleware, noteController.createNote);
router.post('/:po_id/reaction', authMiddleware, noteController.addNoteReaction);

module.exports = router;
