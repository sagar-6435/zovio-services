import { Router } from 'express';
import { verifyLogin } from '../controllers/authController';

const router = Router();

// User auth (via OTP verification)
router.post('/verify', verifyLogin);

export default router;
