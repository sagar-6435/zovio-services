import { Request, Response } from 'express';
import User from '../models/User';

export const updateProfile = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { name, email, mobile } = req.body;

    const updateData: any = { $set: { name, mobile }, $setOnInsert: { role: 'customer' } };
    if (email && email.trim() !== '') {
      updateData.$set.email = email.trim();
    } else {
      updateData.$unset = { email: 1 };
    }

    const updatedUser = await User.findByIdAndUpdate(
      id,
      updateData,
      { new: true, runValidators: true, upsert: true }
    );

    return res.status(200).json({ message: 'Profile updated successfully', user: updatedUser });
  } catch (error) {
    console.error('Error updating profile:', error);
    return res.status(500).json({ message: 'Internal server error' });
  }
};
