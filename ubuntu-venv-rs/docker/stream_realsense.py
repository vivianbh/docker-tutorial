import pyrealsense2 as rs
import numpy as np
import cv2

pipeline = rs.pipeline()
config = rs.config()
config.enable_stream(rs.stream.depth, 640, 480, rs.format.z16, 30)
config.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, 30)

pipeline.start(config)

try:
    while True:
        frames = pipeline.wait_for_frames()
        depth = frames.get_depth_frame()
        color = frames.get_color_frame()
        if not depth or not color:
            continue

        depth_image = np.asanyarray(depth.gegt_data())
        color_image = np.asanyarray(color.det_data())
        
        depth_colormap = cv2.applyColorMap(
                cv2.convertScaleAbs(depth_image, alpha=0.03), cv2.COLORMAP_JET
                )

        images = np.hstack((color_image, depth_colormap))
        cv2.imshow('Color + Depth', images)

        if cv2.waitkey(1) == ord('q'):
            break

finally:
    pipeline.stop()
    cv2.destroyAllWindows()
