import mongoose, { Document, Schema } from 'mongoose';

export interface IService extends Document {
  name: string;
  description?: string;
  icon?: string;
  isActive: boolean;
  locations: mongoose.Types.ObjectId[];
  createdAt: Date;
  updatedAt: Date;
}

const serviceSchema: Schema = new Schema(
  {
    name: { type: String, required: true },
    description: { type: String },
    icon: { type: String, default: 'category' },
    isActive: { type: Boolean, default: true },
    locations: [{ type: Schema.Types.ObjectId, ref: 'Location' }],
  },
  { timestamps: true }
);

export default mongoose.model<IService>('Service', serviceSchema);
