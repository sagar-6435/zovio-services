import express from 'express';
import { loginAdmin, registerAdmin } from '../controllers/authController';
import { getDashboardStats, getUsers, blockUser, approveWorker } from '../controllers/adminController';
import { protect } from '../middleware/authMiddleware';

const router = express.Router();

// Public auth routes
router.post('/login', loginAdmin);
router.post('/register', registerAdmin); // Can be restricted later

// Protected admin routes
router.use(protect);
router.get('/dashboard', getDashboardStats);
router.get('/users', getUsers);
router.put('/users/:id/block', blockUser);
router.put('/workers/:id/approve', approveWorker);

export default router;
