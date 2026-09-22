import cv2
import imageio
from rembg import remove, new_session
import numpy as np
import os

input_path = r"c:\My projects\zovio\client\assets\videos\splash.mp4"
output_path = r"c:\My projects\zovio\client\assets\videos\splash_transparent.gif"

print("Reading video...")
reader = imageio.get_reader(input_path)
fps = reader.get_meta_data()['fps']

print("Processing frames...")
writer = imageio.get_writer(output_path, fps=fps)
session = new_session("u2net")

frame_count = 0
for frame in reader:
    # frame is RGB
    # use rembg to remove background
    out_frame = remove(frame, session=session)
    writer.append_data(out_frame)
    frame_count += 1
    if frame_count % 10 == 0:
        print(f"Processed {frame_count} frames...")

writer.close()
print("Done! Saved to:", output_path)
