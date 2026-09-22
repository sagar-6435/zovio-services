import mongoose, { Document, Schema } from 'mongoose';

export interface ILocation extends Document {
  city: string;
  state: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const locationSchema: Schema = new Schema(
  {
    city: { type: String, required: true },
    state: { type: String, required: true },
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

export default mongoose.model<ILocation>('Location', locationSchema);
