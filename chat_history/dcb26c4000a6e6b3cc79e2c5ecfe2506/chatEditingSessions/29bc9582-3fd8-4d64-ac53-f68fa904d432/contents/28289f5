const { query } = require('../config/database');

// Get user profile
exports.getProfile = async (req, res) => {
  try {
    const { v_id } = req.params;

    const users = await query(
      'SELECT v_id, v_name, v_username, v_birth, created_at FROM variant WHERE v_id = ?',
      [v_id]
    );

    if (users.length === 0) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }

    const user = users[0];

    // Get emails
    const emails = await query('SELECT * FROM variant_email WHERE v_id = ?', [v_id]);

    // Get phone numbers
    const phones = await query('SELECT * FROM variant_number WHERE v_id = ?', [v_id]);

    // Get usernames history
    const usernames = await query('SELECT * FROM variant_username WHERE v_id = ?', [v_id]);

    // Get follower/following counts
    const followers = await query('SELECT COUNT(*) as count FROM follows WHERE followee_id = ?', [v_id]);
    const following = await query('SELECT COUNT(*) as count FROM follows WHERE follower_id = ?', [v_id]);

    // Get post count
    const posts = await query('SELECT COUNT(*) as count FROM post WHERE v_id = ? AND statuse = TRUE', [v_id]);

    res.json({
      success: true,
      data: {
        ...user,
        emails,
        phones,
        usernames,
        followerCount: followers[0].count,
        followingCount: following[0].count,
        postCount: posts[0].count,
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Update profile
exports.updateProfile = async (req, res) => {
  try {
    const { v_id } = req.params;
    const { v_name, v_birth } = req.body;

    const result = await query(
      'UPDATE variant SET v_name = ?, v_birth = ? WHERE v_id = ?',
      [v_name, v_birth, v_id]
    );

    res.json({ success: true, message: 'Profile updated successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Search users
exports.searchUsers = async (req, res) => {
  try {
    const { q } = req.query;

    const results = await query(
      'SELECT v_id, v_name, v_username FROM variant WHERE v_name LIKE ? OR v_username LIKE ? LIMIT 20',
      [`%${q}%`, `%${q}%`]
    );

    res.json({ success: true, data: results });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
