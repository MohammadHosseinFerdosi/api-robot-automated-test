import easyocr
import cv2
import numpy as np
from robot.api.deco import keyword



def extract_texts(image_path):
    reader = easyocr.Reader(['en'])
    img = cv2.imread(image_path)
    result = reader.readtext(img)
    return result

@keyword
def solve_captcha(image_path, expected_length=5, save_for_debug=True, save_location="../debug/processed_image.png"):
    result = extract_texts(image_path)
    img = cv2.imread(image_path)
    img_with_boxes = img.copy()
    for detection in result:
        box = detection[0]
        text = detection[1]
        confidence = detection[2]
        pts = np.array(box, dtype=np.int32)
        pts = pts.reshape((-1, 1, 2))
        cv2.polylines(img_with_boxes, [pts], isClosed=True, color=(0, 255, 0), thickness=2)
        cv2.putText(img_with_boxes, text, (pts[0][0][0], pts[0][0][1] - 10),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 255, 0), 2)
    if save_for_debug:
        cv2.imwrite(save_location, img_with_boxes)

    for detection in result:
        if len(detection[1]) == expected_length and detection[1].isdigit():
                return detection[1]
    return None
