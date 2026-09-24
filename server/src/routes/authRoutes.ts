import { Router } from 'express';
import { verifyLogin, sendOtp } from '../controllers/authController';

const router = Router();

// User auth (via OTP verification)
router.post('/send-otp', sendOtp);
router.post('/verify', verifyLogin);

export default router;
