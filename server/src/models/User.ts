import mongoose, { Document, Schema } from 'mongoose';

export interface IUser extends Document {
  mobile: string;
  name?: string;
  email?: string;
  isBlocked: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const userSchema: Schema = new Schema({
  mobile: { type: String, required: true, unique: true },
  name: { type: String },
  email: { type: String },
  isBlocked: { type: Boolean, default: false },
}, { timestamps: true });

export default mongoose.model<IUser>('User', userSchema);
