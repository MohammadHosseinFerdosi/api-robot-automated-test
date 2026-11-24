from PIL import Image
import cv2
import numpy as np
from robot.api.deco import keyword

# openCV returns (H W C)
# when you resize its order is (W,H)
# w is the x axis
# h is the y axis


@keyword
def get_image_size(image_path):
    '''
    Returns the shape of the image
    '''
    img = cv2.imread(image_path)
    h,w,c = img.shape
    return {"height": h, "width": w, "channels": c}

@keyword
def resize_image(image_path, new_path, new_w = 2000, new_h = 1000):
    '''
    Resize the image and save it as a new image in "new_path"
    Returns the scale factors
    '''
    new_w = int(new_w)
    new_h = int(new_h)
    img = cv2.imread(image_path)
    resized_img = cv2.resize(img, (new_w,new_h))
    cv2.imwrite(new_path, resized_img)

    scale_h = img.shape[0]/new_h
    scale_w = img.shape[1]/new_w

    return scale_h, scale_w

@keyword
def rescale_position(scale_h, scale_w, x, y):
    '''
    Based on the scale factors, returns the new position in the rescaled image
    '''
    return int(x * scale_w), int(y * scale_h)