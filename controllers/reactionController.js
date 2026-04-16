const { query } = require('../config/database');

// Add post reaction
exports.addPostReaction = async (req, res) => {
  try {
    const { p_id } = req.params;
    const { v_id } = req.user || req.body;
    const { pr_type } = req.body;

    const existing = await query(
      'SELECT * FROM post_reaction WHERE p_id = ? AND v_id = ?',
      [p_id, v_id]
    );

    if (existing.length > 0) {
      await query(
        'UPDATE post_reaction SET pr_type = ? WHERE p_id = ? AND v_id = ?',
        [pr_type, p_id, v_id]
      );
    } else {
      await query(
        'INSERT INTO post_reaction (p_id, v_id, pr_type) VALUES (?, ?, ?)',
        [p_id, v_id, pr_type]
      );
    }

    res.json({ success: true, message: 'Reaction added' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Get post reactions
exports.getPostReactions = async (req, res) => {
  try {
    const { p_id } = req.params;

    const reactions = await query(
      `SELECT pr.pr_type, COUNT(*) as count 
       FROM post_reaction pr
       WHERE pr.p_id = ?
       GROUP BY pr.pr_type`,
      [p_id]
    );

    res.json({ success: true, data: reactions });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Remove reaction
exports.removeReaction = async (req, res) => {
  try {
    const { p_id } = req.params;
    const { v_id } = req.user || req.body;

    await query('DELETE FROM post_reaction WHERE p_id = ? AND v_id = ?', [p_id, v_id]);

    res.json({ success: true, message: 'Reaction removed' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
