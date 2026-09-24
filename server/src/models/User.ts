import mongoose, { Document, Schema } from 'mongoose';

export interface IUser extends Document {
  mobile: string;
  name?: string;
  email?: string;
  isBlocked: boolean;
  otp?: string;
  otpExpiry?: Date;
  createdAt: Date;
  updatedAt: Date;
}

const userSchema: Schema = new Schema({
  mobile: { type: String, required: true, unique: true },
  name: { type: String },
  email: { type: String, unique: true, sparse: true },
  role: { type: String, enum: ['customer', 'worker', 'admin'], default: 'customer' },
  isBlocked: { type: Boolean, default: false },
  otp: { type: String },
  otpExpiry: { type: Date },
}, { timestamps: true });

export default mongoose.model<IUser>('User', userSchema);
