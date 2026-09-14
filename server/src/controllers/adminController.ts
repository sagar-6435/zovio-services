import { Request, Response } from 'express';
import User from '../models/User';
import Worker from '../models/Worker';
import Booking from '../models/Booking';
import AdminLog from '../models/AdminLog';
import { AuthRequest } from '../middleware/authMiddleware';
import mongoose from 'mongoose';

const logAction = async (adminId: string, action: string, resource: string, details: any) => {
  await AdminLog.create({ adminId: adminId as any, action, resource, details });
};

export const getDashboardStats = async (req: AuthRequest, res: Response) => {
  try {
    const totalCustomers = await User.countDocuments();
    const totalWorkers = await Worker.countDocuments();
    const activeBookings = await Booking.countDocuments({ status: 'Pending' });
    const completedJobs = await Booking.countDocuments({ status: 'Completed' });

    res.json({ totalCustomers, totalWorkers, activeBookings, completedJobs });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

export const getUsers = async (req: AuthRequest, res: Response) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

export const blockUser = async (req: AuthRequest, res: Response) => {
  try {
    const user = await User.findById(req.params.id);
    if (user) {
      user.isBlocked = !user.isBlocked;
      await user.save();
      await logAction(req.admin._id, user.isBlocked ? 'BLOCK_USER' : 'UNBLOCK_USER', 'User', { userId: user._id });
      res.json({ message: `User ${user.isBlocked ? 'blocked' : 'unblocked'}` });
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

export const approveWorker = async (req: AuthRequest, res: Response) => {
  try {
    const worker = await Worker.findById(req.params.id);
    if (worker) {
      worker.status = 'Approved';
      worker.isVerified = true;
      await worker.save();
      await logAction(req.admin._id, 'APPROVE_WORKER', 'Worker', { workerId: worker._id });
      res.json({ message: 'Worker approved successfully' });
    } else {
      res.status(404).json({ message: 'Worker not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};
