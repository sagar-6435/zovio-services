import mongoose, { Document, Schema } from 'mongoose';

export interface IWorker extends Document {
  name: string;
  role: string;
  rating: number;
  imageUrl: string;
  description?: string;
  status: 'Pending' | 'Approved' | 'Rejected' | 'Inactive';
  isVerified: boolean;
  documents: string[];
  createdAt: Date;
  updatedAt: Date;
}

const workerSchema: Schema = new Schema(
  {
    name: { type: String, required: true },
    role: { type: String, required: true },
    rating: { type: Number, default: 0 },
    imageUrl: { type: String, required: true },
    description: { type: String },
    status: { type: String, enum: ['Pending', 'Approved', 'Rejected', 'Inactive'], default: 'Pending' },
    isVerified: { type: Boolean, default: false },
    documents: [{ type: String }],
  },
  { timestamps: true }
);

export default mongoose.model<IWorker>('Worker', workerSchema);
