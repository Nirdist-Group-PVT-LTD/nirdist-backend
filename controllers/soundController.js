const { query } = require('../config/database');

// Get all sounds
exports.getAllSounds = async (req, res) => {
  try {
    const { page = 1, limit = 20, q = '' } = req.query;
    const offset = (page - 1) * limit;

    const sounds = await query(
      `SELECT s.*, sa.s_a_name,
              COUNT(DISTINCT p.p_id) as usageCount
       FROM sound s
       LEFT JOIN sound_artist sa ON s.s_a_id = sa.s_a_id
       LEFT JOIN post p ON s.s_id = p.s_id
       WHERE sa.s_a_name LIKE ? OR s.lyrics LIKE ?
       GROUP BY s.s_id
       ORDER BY usageCount DESC
       LIMIT ? OFFSET ?`,
      [`%${q}%`, `%${q}%`, parseInt(limit), offset]
    );

    res.json({ success: true, data: sounds });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Get user produced sounds
exports.getUserSounds = async (req, res) => {
  try {
    const { v_id } = req.params;

    const sounds = await query(
      'SELECT * FROM sound_produce WHERE v_id = ? ORDER BY sp_time DESC',
      [v_id]
    );

    res.json({ success: true, data: sounds });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Create user sound
exports.createSound = async (req, res) => {
  try {
    const { v_id } = req.user || req.body;
    const { sp_name, sp_discription } = req.body;

    if (!req.file) {
      return res.status(400).json({ success: false, message: 'No audio file uploaded' });
    }

    const result = await query(
      'INSERT INTO sound_produce (v_id, sp_name, sp_discription, sp_link) VALUES (?, ?, ?, ?)',
      [v_id, sp_name, sp_discription, `/uploads/${req.file.filename}`]
    );

    res.status(201).json({
      success: true,
      message: 'Sound created successfully',
      data: { sp_id: result.insertId },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
