import express from 'express';
import { createBooking, getBookings } from '../controllers/bookingController';

const router = express.Router();

router.route('/')
  .post(createBooking)
  .get(getBookings);

export default router;
