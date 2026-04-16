const { query } = require('../config/database');

// Get notes
exports.getNotes = async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;

    const notes = await query(
      `SELECT n.*, v.v_name, v.v_username,
              COUNT(DISTINCT nr.nr_id) as reactionCount
       FROM notes n
       JOIN variant v ON n.v_id = v.v_id
       LEFT JOIN notes_reaction nr ON n.po_id = nr.note_id
       WHERE n.visibility = 'public'
       GROUP BY n.po_id
       ORDER BY n.note_time DESC
       LIMIT ? OFFSET ?`,
      [parseInt(limit), offset]
    );

    res.json({ success: true, data: notes });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Create note
exports.createNote = async (req, res) => {
  try {
    const { v_id } = req.user || req.body;
    const { note_content, visibility = 'public' } = req.body;

    const result = await query(
      'INSERT INTO notes (v_id, note_content, visibility) VALUES (?, ?, ?)',
      [v_id, note_content, visibility]
    );

    res.status(201).json({
      success: true,
      message: 'Note created successfully',
      data: { po_id: result.insertId },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Add note reaction
exports.addNoteReaction = async (req, res) => {
  try {
    const { po_id } = req.params;
    const { v_id } = req.user || req.body;
    const { reaction_type } = req.body;

    const existing = await query(
      'SELECT * FROM notes_reaction WHERE note_id = ? AND v_id = ?',
      [po_id, v_id]
    );

    if (existing.length > 0) {
      await query(
        'UPDATE notes_reaction SET reaction_type = ? WHERE note_id = ? AND v_id = ?',
        [reaction_type, po_id, v_id]
      );
    } else {
      await query(
        'INSERT INTO notes_reaction (note_id, v_id, reaction_type) VALUES (?, ?, ?)',
        [po_id, v_id, reaction_type]
      );
    }

    res.json({ success: true, message: 'Reaction added' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
