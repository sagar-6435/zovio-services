import { Request, Response } from 'express';
import Location from '../models/Location';

export const getLocations = async (req: Request, res: Response) => {
  try {
    const locations = await Location.find().sort({ createdAt: -1 });
    res.status(200).json(locations);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

export const createLocation = async (req: Request, res: Response) => {
  try {
    const { city, state, isActive } = req.body;
    const location = new Location({ city, state, isActive });
    await location.save();
    res.status(201).json(location);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

export const updateLocation = async (req: Request, res: Response) => {
  try {
    const { city, state, isActive } = req.body;
    const location = await Location.findByIdAndUpdate(
      req.params.id,
      { city, state, isActive },
      { new: true, runValidators: true }
    );
    if (!location) {
      return res.status(404).json({ message: 'Location not found' });
    }
    res.status(200).json(location);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

export const deleteLocation = async (req: Request, res: Response) => {
  try {
    const location = await Location.findByIdAndDelete(req.params.id);
    if (!location) {
      return res.status(404).json({ message: 'Location not found' });
    }
    res.status(200).json({ message: 'Location deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};
