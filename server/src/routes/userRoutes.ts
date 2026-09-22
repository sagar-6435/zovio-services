import { Router } from 'express';
import { updateProfile } from '../controllers/userController';

const router = Router();

// PUT /api/users/profile/:id
router.put('/profile/:id', updateProfile);

export default router;
