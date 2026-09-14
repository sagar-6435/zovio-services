import { Request, Response } from 'express';
import Booking from '../models/Booking';
import Worker from '../models/Worker';
import { sendWhatsAppMessage } from '../services/whatsappService';

export const createBooking = async (req: Request, res: Response) => {
  try {
    const { workerId, mobile, date, time, location } = req.body;

    const booking = new Booking({
      workerId,
      mobile,
      date,
      time,
      location,
      status: 'Pending',
    });

    await booking.save();

    // Trigger WhatsApp integration
    const worker = await Worker.findById(workerId);
    const workerName = worker ? worker.name : 'a worker';
    
    const message = `Hello! I would like to book ${workerName}.\nMobile: ${mobile}\nDate: ${date}\nTime: ${time}\nLocation: ${location}`;
    
    const adminMobileString = process.env.Admin_mobile || process.env.admin_mobile || '+918897536435';
    const adminMobiles = adminMobileString.split(',');
    
    for (const adminMobile of adminMobiles) {
      const number = adminMobile.trim();
      if (number) {
        await sendWhatsAppMessage(number, message);
      }
    }
    
    res.status(201).json(booking);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

export const getBookings = async (req: Request, res: Response) => {
  try {
    const bookings = await Booking.find().populate('workerId');
    res.json(bookings);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};
