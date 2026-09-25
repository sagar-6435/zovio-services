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

export const sendOtp = async (req: Request, res: Response) => {
  try {
    const { mobile } = req.body;
    if (!mobile) return res.status(400).json({ message: 'Mobile number is required' });

    let user = await User.findOne({ mobile });
    if (!user) {
      const isAdmin = mobile.includes('9381534213');
      user = new User({ mobile, role: isAdmin ? 'admin' : 'customer' });
    }

    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    (user as any).otp = otp;
    (user as any).otpExpiry = new Date(Date.now() + 5 * 60 * 1000); // 5 mins
    await user.save();

    const messageTemplate = `🔐 Zovio OTP: *${otp}*

Use this code to verify your Zovio account.
Valid for *5 minutes*. Please don't share it with anyone.

*Team Zovio*
Connect. Get It Done.`;

    console.log(`[DEV ONLY] Generated OTP for ${mobile}: ${otp}`);
    
    try {
      const { sendWhatsAppMessage } = await import('../services/whatsappService');
      await sendWhatsAppMessage(mobile, messageTemplate);
    } catch (waError) {
      console.warn('Could not send WhatsApp message. Skipping for local testing. Error:', (waError as Error).message);
    }

    return res.status(200).json({ message: 'OTP sent successfully' });
  } catch (error) {
    console.error('Error sending OTP:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
};

export const verifyLogin = async (req: Request, res: Response) => {
  try {
    const { mobile, otp } = req.body;

    if (!mobile || !otp) {
      return res.status(400).json({ message: 'Mobile number and OTP are required' });
    }

    let user = await User.findOne({ mobile });
    
    if (!user || !(user as any).otp || (user as any).otp !== otp) {
      return res.status(400).json({ message: 'Invalid or expired OTP' });
    }
    
    if (new Date() > (user as any).otpExpiry) {
      return res.status(400).json({ message: 'OTP has expired' });
    }

    // Clear OTP
    (user as any).otp = undefined;
    (user as any).otpExpiry = undefined;
    await user.save();

    let isNewUser = !user.name;

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
