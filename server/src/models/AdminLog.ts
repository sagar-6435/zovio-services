import mongoose, { Document, Schema } from 'mongoose';

export interface IAdminLog extends Document {
  adminId: mongoose.Schema.Types.ObjectId;
  action: string;
  resource: string;
  details: any;
  createdAt: Date;
}

const adminLogSchema: Schema = new Schema({
  adminId: { type: mongoose.Schema.Types.ObjectId, ref: 'Admin', required: true },
  action: { type: String, required: true },
  resource: { type: String, required: true },
  details: { type: Schema.Types.Mixed },
}, { timestamps: { createdAt: true, updatedAt: false } });

export default mongoose.model<IAdminLog>('AdminLog', adminLogSchema);
