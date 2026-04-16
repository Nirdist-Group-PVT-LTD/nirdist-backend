const { query } = require('../config/database');

// Get post comments
exports.getComments = async (req, res) => {
  try {
    const { p_id } = req.params;

    const comments = await query(
      `SELECT pc.*, v.v_name, v.v_username
       FROM post_comment pc
       JOIN variant v ON pc.v_id = v.v_id
       WHERE pc.post_id = ? AND pc.parent_comment_id IS NULL
       ORDER BY pc.created_at DESC`,
      [p_id]
    );

    // Get replies for each comment
    for (let comment of comments) {
      const replies = await query(
        `SELECT pc.*, v.v_name, v.v_username
         FROM post_comment pc
         JOIN variant v ON pc.v_id = v.v_id
         WHERE pc.parent_comment_id = ?
         ORDER BY pc.created_at ASC`,
        [comment.post_comment_id]
      );
      comment.replies = replies;

      // Get reactions for comment
      const reactions = await query(
        `SELECT pcr.reaction_type, COUNT(*) as count 
         FROM post_comment_reaction pcr
         WHERE pcr.comment_id = ?
         GROUP BY pcr.reaction_type`,
        [comment.post_comment_id]
      );
      comment.reactions = reactions;
    }

    res.json({ success: true, data: comments });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Add comment
exports.addComment = async (req, res) => {
  try {
    const { p_id } = req.params;
    const { v_id } = req.user || req.body;
    const { post_comment_text, parent_comment_id } = req.body;

    const result = await query(
      'INSERT INTO post_comment (post_id, v_id, post_comment_text, parent_comment_id) VALUES (?, ?, ?, ?)',
      [p_id, v_id, post_comment_text, parent_comment_id || null]
    );

    // Get the new comment
    const comments = await query(
      `SELECT pc.*, v.v_name, v.v_username
       FROM post_comment pc
       JOIN variant v ON pc.v_id = v.v_id
       WHERE pc.post_comment_id = ?`,
      [result.insertId]
    );

    res.status(201).json({
      success: true,
      message: 'Comment added successfully',
      data: comments[0],
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Delete comment
exports.deleteComment = async (req, res) => {
  try {
    const { comment_id } = req.params;
    const { v_id } = req.user || req.body;

    // Verify ownership
    const comments = await query('SELECT v_id FROM post_comment WHERE post_comment_id = ?', [comment_id]);
    if (comments.length === 0 || comments[0].v_id !== v_id) {
      return res.status(403).json({ success: false, message: 'Unauthorized' });
    }

    await query('DELETE FROM post_comment WHERE post_comment_id = ?', [comment_id]);

    res.json({ success: true, message: 'Comment deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
