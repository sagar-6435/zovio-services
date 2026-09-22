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
    const { name, role, rating, description, status, imageUrl: bodyImageUrl } = req.body;
    let imageUrl = bodyImageUrl || '';

    if (req.file) {
      imageUrl = req.file.path; // Cloudinary URL
    } else if (!imageUrl) {
      return res.status(400).json({ message: 'Image is required' });
    }

    const worker = new Worker({
      name,
      role,
      rating: rating || 0,
      description,
      imageUrl,
      status: status || 'Pending',
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
    worker.rating = req.body.rating !== undefined ? req.body.rating : worker.rating;
    worker.description = req.body.description || worker.description;
    
    if (req.body.status) {
      worker.status = req.body.status;
    }

    if (req.file) {
      worker.imageUrl = req.file.path;
    } else if (req.body.imageUrl) {
      worker.imageUrl = req.body.imageUrl;
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
