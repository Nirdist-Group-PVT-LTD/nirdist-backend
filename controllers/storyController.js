const { query } = require('../config/database');

// Get stories (active within 24h)
exports.getStories = async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;

    const stories = await query(
      `SELECT s.*, v.v_name, v.v_username 
       FROM story s
       JOIN variant v ON s.v_id = v.v_id
       WHERE s.expires_at > NOW()
       ORDER BY s.s_time DESC
       LIMIT ? OFFSET ?`,
      [parseInt(limit), offset]
    );

    res.json({ success: true, data: stories });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Create story
exports.createStory = async (req, res) => {
  try {
    const { v_id } = req.user || req.body;

    if (!req.file) {
      return res.status(400).json({ success: false, message: 'No file uploaded' });
    }

    const result = await query(
      'INSERT INTO story (v_id, s_link) VALUES (?, ?)',
      [v_id, `/uploads/${req.file.filename}`]
    );

    res.status(201).json({
      success: true,
      message: 'Story created successfully',
      data: { s_id: result.insertId },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Add story reaction
exports.addStoryReaction = async (req, res) => {
  try {
    const { s_id } = req.params;
    const { v_id } = req.user || req.body;
    const { sr_type } = req.body;

    // Check if reaction exists
    const existing = await query(
      'SELECT * FROM story_reaction WHERE v_id = ? AND s_id = ?',
      [v_id, s_id]
    );

    if (existing.length > 0) {
      // Update reaction
      await query(
        'UPDATE story_reaction SET sr_type = ? WHERE v_id = ? AND s_id = ?',
        [sr_type, v_id, s_id]
      );
    } else {
      // Create new reaction
      await query(
        'INSERT INTO story_reaction (v_id, s_id, sr_type) VALUES (?, ?, ?)',
        [v_id, s_id, sr_type]
      );
    }

    res.json({ success: true, message: 'Reaction added' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
