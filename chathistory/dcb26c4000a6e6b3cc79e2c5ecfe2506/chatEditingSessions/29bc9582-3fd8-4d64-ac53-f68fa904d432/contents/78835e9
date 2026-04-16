const { query } = require('../config/database');

// Follow user
exports.followUser = async (req, res) => {
  try {
    const { followee_id } = req.params;
    const { v_id } = req.user || req.body;

    if (v_id === parseInt(followee_id)) {
      return res.status(400).json({ success: false, message: 'Cannot follow yourself' });
    }

    const existing = await query(
      'SELECT * FROM follows WHERE follower_id = ? AND followee_id = ?',
      [v_id, followee_id]
    );

    if (existing.length > 0) {
      return res.status(400).json({ success: false, message: 'Already following' });
    }

    await query(
      'INSERT INTO follows (follower_id, followee_id) VALUES (?, ?)',
      [v_id, followee_id]
    );

    res.status(201).json({ success: true, message: 'User followed successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Unfollow user
exports.unfollowUser = async (req, res) => {
  try {
    const { followee_id } = req.params;
    const { v_id } = req.user || req.body;

    await query(
      'DELETE FROM follows WHERE follower_id = ? AND followee_id = ?',
      [v_id, followee_id]
    );

    res.json({ success: true, message: 'User unfollowed successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Get followers
exports.getFollowers = async (req, res) => {
  try {
    const { v_id } = req.params;
    const { page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;

    const followers = await query(
      `SELECT v.v_id, v.v_name, v.v_username, f.follow_time
       FROM follows f
       JOIN variant v ON f.follower_id = v.v_id
       WHERE f.followee_id = ?
       ORDER BY f.follow_time DESC
       LIMIT ? OFFSET ?`,
      [v_id, parseInt(limit), offset]
    );

    res.json({ success: true, data: followers });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Get following
exports.getFollowing = async (req, res) => {
  try {
    const { v_id } = req.params;
    const { page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;

    const following = await query(
      `SELECT v.v_id, v.v_name, v.v_username, f.follow_time
       FROM follows f
       JOIN variant v ON f.followee_id = v.v_id
       WHERE f.follower_id = ?
       ORDER BY f.follow_time DESC
       LIMIT ? OFFSET ?`,
      [v_id, parseInt(limit), offset]
    );

    res.json({ success: true, data: following });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Check if following
exports.isFollowing = async (req, res) => {
  try {
    const { target_id } = req.params;
    const { v_id } = req.user || req.body;

    const result = await query(
      'SELECT * FROM follows WHERE follower_id = ? AND followee_id = ?',
      [v_id, target_id]
    );

    res.json({ success: true, data: { isFollowing: result.length > 0 } });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
