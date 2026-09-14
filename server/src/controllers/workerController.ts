import { Request, Response } from 'express';
import Worker from '../models/Worker';

export const getWorkers = async (req: Request, res: Response) => {
  try {
    const workers = await Worker.find();
    res.json(workers);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
};

export const createWorker = async (req: Request, res: Response) => {
  try {
    const { name, role, rating, description } = req.body;
    let imageUrl = '';

    if (req.file) {
      imageUrl = req.file.path; // Cloudinary URL
    } else {
      return res.status(400).json({ message: 'Image is required' });
    }

    const worker = new Worker({
      name,
      role,
      rating: rating || 0,
      description,
      imageUrl,
    });

    await worker.save();
    res.status(201).json(worker);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

export const updateWorker = async (req: Request, res: Response) => {
  try {
    const worker = await Worker.findById(req.params.id);
    if (!worker) return res.status(404).json({ message: 'Worker not found' });

    worker.name = req.body.name || worker.name;
    worker.role = req.body.role || worker.role;
    worker.rating = req.body.rating || worker.rating;
    worker.description = req.body.description || worker.description;

    if (req.file) {
      worker.imageUrl = req.file.path;
    }

    const updatedWorker = await worker.save();
    res.json(updatedWorker);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

export const deleteWorker = async (req: Request, res: Response) => {
  try {
    const worker = await Worker.findById(req.params.id);
    if (!worker) return res.status(404).json({ message: 'Worker not found' });

    await worker.deleteOne();
    res.json({ message: 'Worker removed' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};
