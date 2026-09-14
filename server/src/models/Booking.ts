import mongoose, { Document, Schema } from 'mongoose';

export interface IBooking extends Document {
  workerId: mongoose.Schema.Types.ObjectId;
  mobile: string;
  date: string;
  time: string;
  location: string;
  status: 'Pending' | 'Confirmed' | 'Completed' | 'Cancelled';
  createdAt: Date;
  updatedAt: Date;
}

const bookingSchema: Schema = new Schema(
  {
    workerId: { type: mongoose.Schema.Types.ObjectId, ref: 'Worker' },
    mobile: { type: String, required: true },
    date: { type: String, required: true },
    time: { type: String, required: true },
    location: { type: String, required: true },
    status: { 
      type: String, 
      enum: ['Pending', 'Confirmed', 'Completed', 'Cancelled'],
      default: 'Pending' 
    },
  },
  { timestamps: true }
);

export default mongoose.model<IBooking>('Booking', bookingSchema);
