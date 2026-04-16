const { query } = require('../config/database');

// Get user feed
exports.getFeed = async (req, res) => {
  try {
    const { algorithmId, page = 1, limit = 10 } = req.query;
    const offset = (page - 1) * limit;

    let sql = `
      SELECT p.*, 
             v.v_name, v.v_username,
             COUNT(DISTINCT pr.pr_id) as reactionCount,
             COUNT(DISTINCT pc.post_comment_id) as commentCount,
             COUNT(DISTINCT ps.p_s_id) as shareCount,
             COUNT(DISTINCT psa.p_sa_id) as saveCount
      FROM post p
      JOIN variant v ON p.v_id = v.v_id
      LEFT JOIN post_reaction pr ON p.p_id = pr.p_id
      LEFT JOIN post_comment pc ON p.p_id = pc.post_id
      LEFT JOIN post_share ps ON p.p_id = ps.p_id
      LEFT JOIN post_save psa ON p.p_id = psa.p_id
      WHERE p.statuse = TRUE
    `;

    if (algorithmId) {
      sql += ` AND p.a_id = ?`;
    }

    sql += ` GROUP BY p.p_id ORDER BY p.post_time DESC LIMIT ? OFFSET ?`;

    const values = algorithmId ? [algorithmId, parseInt(limit), offset] : [parseInt(limit), offset];
    const posts = await query(sql, values);

    // Get media for each post
    for (let post of posts) {
      const media = await query('SELECT * FROM post_media WHERE p_id = ?', [post.p_id]);
      post.media = media;

      // Get sound info if exists
      if (post.s_id) {
        const sounds = await query('SELECT * FROM sound WHERE s_id = ?', [post.s_id]);
        post.sound = sounds[0];
      }
    }

    res.json({ success: true, data: posts });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Create post
exports.createPost = async (req, res) => {
  try {
    const { v_id } = req.user || { v_id: req.body.v_id };
    const { discription, s_id } = req.body;

    const result = await query(
      'INSERT INTO post (v_id, discription, s_id, statuse) VALUES (?, ?, ?, TRUE)',
      [v_id, discription, s_id || null]
    );

    const p_id = result.insertId;

    // Handle media uploads
    if (req.files && req.files.length > 0) {
      for (let file of req.files) {
        await query(
          'INSERT INTO post_media (p_id, p_m_link) VALUES (?, ?)',
          [p_id, `/uploads/${file.filename}`]
        );
      }
    }

    res.status(201).json({
      success: true,
      message: 'Post created successfully',
      data: { p_id },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Get post details
exports.getPost = async (req, res) => {
  try {
    const { p_id } = req.params;

    const posts = await query(
      `SELECT p.*, v.v_name, v.v_username 
       FROM post p
       JOIN variant v ON p.v_id = v.v_id
       WHERE p.p_id = ?`,
      [p_id]
    );

    if (posts.length === 0) {
      return res.status(404).json({ success: false, message: 'Post not found' });
    }

    const post = posts[0];

    // Get media
    const media = await query('SELECT * FROM post_media WHERE p_id = ?', [p_id]);
    post.media = media;

    // Get reactions with user info
    const reactions = await query(
      `SELECT pr.*, v.v_name, v.v_username 
       FROM post_reaction pr
       JOIN variant v ON pr.v_id = v.v_id
       WHERE pr.p_id = ?`,
      [p_id]
    );
    post.reactions = reactions;

    res.json({ success: true, data: post });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Delete post
exports.deletePost = async (req, res) => {
  try {
    const { p_id } = req.params;
    const { v_id } = req.user || req.body;

    // Verify ownership
    const posts = await query('SELECT v_id FROM post WHERE p_id = ?', [p_id]);
    if (posts.length === 0 || posts[0].v_id !== v_id) {
      return res.status(403).json({ success: false, message: 'Unauthorized' });
    }

    await query('DELETE FROM post WHERE p_id = ?', [p_id]);

    res.json({ success: true, message: 'Post deleted successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
