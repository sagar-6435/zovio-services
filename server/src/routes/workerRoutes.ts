import express from 'express';
import { getWorkers, createWorker, updateWorker, deleteWorker } from '../controllers/workerController';
import { upload } from '../config/cloudinary';

const router = express.Router();

router.route('/')
  .get(getWorkers)
  .post(upload.single('image'), createWorker);

router.route('/:id')
  .put(upload.single('image'), updateWorker)
  .delete(deleteWorker);

export default router;
