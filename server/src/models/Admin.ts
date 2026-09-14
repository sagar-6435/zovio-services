import mongoose, { Document, Schema } from 'mongoose';
import bcrypt from 'bcryptjs';

export interface IAdmin extends Document {
  email: string;
  passwordHash: string;
  role: 'SuperAdmin' | 'Moderator' | 'Support';
  comparePassword(password: string): Promise<boolean>;
}

const adminSchema: Schema = new Schema({
  email: { type: String, required: true, unique: true },
  passwordHash: { type: String, required: true },
  role: { type: String, enum: ['SuperAdmin', 'Moderator', 'Support'], default: 'Moderator' },
}, { timestamps: true });

adminSchema.methods.comparePassword = async function (password: string) {
  return await bcrypt.compare(password, this.passwordHash);
};

export default mongoose.model<IAdmin>('Admin', adminSchema);
