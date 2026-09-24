import express from 'express';
import { getLocations, createLocation, updateLocation, deleteLocation, checkServiceability } from '../controllers/locationController';

const router = express.Router();

router.post('/check-serviceability', checkServiceability);

router.route('/')
  .get(getLocations)
  .post(createLocation);

router.route('/:id')
  .put(updateLocation)
  .delete(deleteLocation);

export default router;
