import mongoose, { Document, Schema } from 'mongoose';

export interface ILocation extends Document {
  city: string;
  state: string;
  latitude: number;
  longitude: number;
  radius: number;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const locationSchema: Schema = new Schema(
  {
    city: { type: String, required: true },
    state: { type: String, required: true },
    latitude: { type: Number, required: true, default: 0 },
    longitude: { type: Number, required: true, default: 0 },
    radius: { type: Number, required: true, default: 5 }, // default 5km radius
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

export default mongoose.model<ILocation>('Location', locationSchema);
