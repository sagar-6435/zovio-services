import express from 'express';
import { createBooking, getBookings, updateBookingStatus } from '../controllers/bookingController';

const router = express.Router();

router.route('/')
  .post(createBooking)
  .get(getBookings);

router.patch('/:id/status', updateBookingStatus);

export default router;
