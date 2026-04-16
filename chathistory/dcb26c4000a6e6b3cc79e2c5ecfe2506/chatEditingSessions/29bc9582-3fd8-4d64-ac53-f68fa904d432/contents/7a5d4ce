const { query } = require('../config/database');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { validationResult } = require('express-validator');

// Register new user
exports.register = async (req, res) => {
  try {
    const { v_name, v_username, email, phone, password } = req.body;

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Insert user
    const result = await query(
      'INSERT INTO variant (v_name, v_username, password) VALUES (?, ?, ?)',
      [v_name, v_username, hashedPassword]
    );

    const v_id = result.insertId;

    // Insert email if provided
    if (email) {
      await query(
        'INSERT INTO variant_email (v_id, email) VALUES (?, ?)',
        [v_id, email]
      );
    }

    // Insert phone if provided
    if (phone) {
      await query(
        'INSERT INTO variant_number (v_id, phone_number) VALUES (?, ?)',
        [v_id, phone]
      );
    }

    // Generate token
    const token = jwt.sign({ v_id }, process.env.JWT_SECRET, {
      expiresIn: process.env.JWT_EXPIRE,
    });

    res.status(201).json({
      success: true,
      message: 'User registered successfully',
      token,
      user: { v_id, v_name, v_username },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Login
exports.login = async (req, res) => {
  try {
    const { v_username, password } = req.body;

    // Find user
    const users = await query(
      'SELECT * FROM variant WHERE v_username = ?',
      [v_username]
    );

    if (users.length === 0) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    const user = users[0];

    // Check password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    // Generate token
    const token = jwt.sign({ v_id: user.v_id }, process.env.JWT_SECRET, {
      expiresIn: process.env.JWT_EXPIRE,
    });

    res.json({
      success: true,
      message: 'Logged in successfully',
      token,
      user: { v_id: user.v_id, v_name: user.v_name, v_username: user.v_username },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
