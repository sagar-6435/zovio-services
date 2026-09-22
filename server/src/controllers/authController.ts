import { Request, Response } from 'express';
import Admin from '../models/Admin';
import User from '../models/User';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';

const generateToken = (id: string) => {
  return jwt.sign({ id }, process.env.JWT_SECRET || 'secret', {
    expiresIn: '30d',
  });
};

export const loginAdmin = async (req: Request, res: Response) => {
  const { email, password } = req.body;

  try {
    const admin = await Admin.findOne({ email });

    if (admin && (await admin.comparePassword(password))) {
      res.json({
        _id: admin._id,
        email: admin.email,
        role: admin.role,
        token: generateToken((admin._id as any).toString()),
      });
    } else {
      res.status(401).json({ message: 'Invalid email or password' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

export const registerAdmin = async (req: Request, res: Response) => {
  const { email, password, role } = req.body;

  try {
    const adminExists = await Admin.findOne({ email });
    if (adminExists) {
      return res.status(400).json({ message: 'Admin already exists' });
    }

    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    const admin = await Admin.create({
      email,
      passwordHash,
      role: role || 'Moderator',
    });

    if (admin) {
      res.status(201).json({
        _id: admin._id,
        email: admin.email,
        role: admin.role,
        token: generateToken((admin._id as any).toString()),
      });
    } else {
      res.status(400).json({ message: 'Invalid admin data' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

export const verifyLogin = async (req: Request, res: Response) => {
  try {
    const { mobile } = req.body;

    if (!mobile) {
      return res.status(400).json({ message: 'Mobile number is required' });
    }

    let user = await User.findOne({ mobile });
    let isNewUser = false;

    // Check if this number belongs to an admin
    const isAdmin = mobile.includes('9381534213');

    if (!user) {
      user = new User({ mobile, role: isAdmin ? 'admin' : 'customer' });
      await user.save();
      isNewUser = true;
    } else {
      // Determine if setup is incomplete (e.g. name is missing)
      isNewUser = !user.name;
      
      // Override role for admin if it wasn't set correctly
      if (isAdmin && (user as any).role !== 'admin') {
        (user as any).role = 'admin';
        await user.save();
      }
    }

    return res.status(200).json({
      message: 'Verified successfully',
      user: {
        _id: user._id,
        mobile: user.mobile,
        name: user.name,
        role: (user as any).role || 'customer'
      },
      isNewUser,
      token: generateToken((user._id as any).toString()),
    });
  } catch (error) {
    console.error('Error in verifyLogin:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
};
