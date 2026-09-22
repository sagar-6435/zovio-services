import { Request, Response } from 'express';
import Service from '../models/Service';

export const getServices = async (req: Request, res: Response) => {
  try {
    const services = await Service.find().populate('locations').sort({ createdAt: -1 });
    res.status(200).json(services);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

export const createService = async (req: Request, res: Response) => {
  try {
    const { name, description, icon, isActive, locations } = req.body;
    const service = new Service({ name, description, icon, isActive, locations });
    await service.save();
    const populatedService = await service.populate('locations');
    res.status(201).json(populatedService);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

export const updateService = async (req: Request, res: Response) => {
  try {
    const { name, description, icon, isActive, locations } = req.body;
    const service = await Service.findByIdAndUpdate(
      req.params.id,
      { name, description, icon, isActive, locations },
      { returnDocument: 'after', runValidators: true }
    ).populate('locations');
    
    if (!service) {
      return res.status(404).json({ message: 'Service not found' });
    }
    res.status(200).json(service);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

export const deleteService = async (req: Request, res: Response) => {
  try {
    const service = await Service.findByIdAndDelete(req.params.id);
    if (!service) {
      return res.status(404).json({ message: 'Service not found' });
    }
    res.status(200).json({ message: 'Service deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};
