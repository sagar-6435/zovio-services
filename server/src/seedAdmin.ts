import mongoose from 'mongoose';
import bcrypt from 'bcryptjs';
import dotenv from 'dotenv';
import Admin from './models/Admin';

dotenv.config();

const seedAdmin = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI as string);
    console.log('MongoDB Connected');

    const email = 'admin@zovio.com';
    const password = 'admin@123';

    const adminExists = await Admin.findOne({ email });
    if (adminExists) {
      console.log('Admin already exists!');
      process.exit();
    }

    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    await Admin.create({
      email,
      passwordHash,
      role: 'SuperAdmin',
    });

    console.log(`Admin created successfully: ${email} / ${password}`);
    process.exit();
  } catch (error) {
    console.error('Error seeding admin:', error);
    process.exit(1);
  }
};

seedAdmin();
