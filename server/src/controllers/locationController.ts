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
    const { city, state, isActive, latitude, longitude, radius } = req.body;
    const location = new Location({ city, state, isActive, latitude, longitude, radius });
    await location.save();
    res.status(201).json(location);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

export const updateLocation = async (req: Request, res: Response) => {
  try {
    const { city, state, isActive, latitude, longitude, radius } = req.body;
    const location = await Location.findByIdAndUpdate(
      req.params.id,
      { city, state, isActive, latitude, longitude, radius },
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

const getDistanceFromLatLonInKm = (lat1: number, lon1: number, lat2: number, lon2: number) => {
  const R = 6371; // Radius of the earth in km
  const dLat = (lat2 - lat1) * (Math.PI / 180);
  const dLon = (lon2 - lon1) * (Math.PI / 180);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * (Math.PI / 180)) * Math.cos(lat2 * (Math.PI / 180)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const d = R * c; // Distance in km
  return d;
};

export const checkServiceability = async (req: Request, res: Response) => {
  try {
    const { latitude, longitude } = req.body;
    
    if (latitude === undefined || longitude === undefined) {
      return res.status(400).json({ message: 'Latitude and longitude are required' });
    }

    const activeLocations = await Location.find({ isActive: true });
    
    let isServiceable = false;
    let serviceableLocation = null;

    for (const location of activeLocations) {
      const distance = getDistanceFromLatLonInKm(
        Number(latitude),
        Number(longitude),
        location.latitude,
        location.longitude
      );

      if (distance <= location.radius) {
        isServiceable = true;
        serviceableLocation = location;
        break;
      }
    }

    res.status(200).json({
      isServiceable,
      location: serviceableLocation,
    });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};
