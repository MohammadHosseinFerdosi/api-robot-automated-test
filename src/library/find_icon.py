import cv2
from robot.api.deco import keyword
import numpy as np

def find_center(kp1, kp2, matches, img_shape):
    '''
    Find the center of the matched icon in the source image using keypoints and matches.
    '''
    src_pts = np.float32([kp1[m.queryIdx].pt for m in matches]).reshape(-1, 1, 2)
    dst_pts = np.float32([kp2[m.trainIdx].pt for m in matches]).reshape(-1, 1, 2)

    center_x = int(np.mean(src_pts[:, 0, 0]))
    center_y = int(np.mean(src_pts[:, 0, 1]))

    top_left = (int(np.min(src_pts[:, 0, 0])), int(np.min(src_pts[:, 0, 1])))
    bottom_right = (int(np.max(src_pts[:, 0, 0])), int(np.max(src_pts[:, 0, 1])))

    return [center_x, center_y], top_left, bottom_right

def feature_based_matching(page_img, icon_img, gray_scale=False, method='SIFT'):
    '''
    Perform feature-based matching using SIFT or ORB.
    '''
    if gray_scale:
        page_img = cv2.cvtColor(page_img, cv2.COLOR_BGR2GRAY)
        icon_img = cv2.cvtColor(icon_img, cv2.COLOR_BGR2GRAY)

    if method == 'SIFT':
        detector = cv2.SIFT_create()
    elif method == 'ORB':
        detector = cv2.ORB_create()
    else:
        raise ValueError("Invalid method. Use 'SIFT' or 'ORB'.")

    kp1, des1 = detector.detectAndCompute(page_img, None)
    kp2, des2 = detector.detectAndCompute(icon_img, None)

    if method == 'SIFT':
        FLANN_INDEX_KDTREE = 1
        index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5)
        search_params = dict(checks=50)
        matcher = cv2.FlannBasedMatcher(index_params, search_params)
    else:
        matcher = cv2.BFMatcher(cv2.NORM_HAMMING, crossCheck=True)

    matches = matcher.match(des1, des2)

    matches = sorted(matches, key=lambda x: x.distance)

    return kp1, kp2, matches

def find_icon(page_img_paths, icon_img_path, gray_scale=False, method='SIFT', num_matches=10):
    '''
    Find the icon in a list of page images using feature-based matching.
    '''
    best = {'best_solution': None, 'best_solution_index': 0, 'loc': [0, 0], 'matches': []}

    for i, page_img_path in enumerate(page_img_paths):
        page_img = cv2.imread(page_img_path)        
        icon_img = cv2.imread(icon_img_path)

        kp1, kp2, matches = feature_based_matching(page_img, icon_img, gray_scale, method)

        num_matches = min(len(matches), num_matches)
        match_quality = np.mean([m.distance for m in matches[:num_matches]])

        if best['best_solution'] is None or match_quality < best['best_solution']:
            best['best_solution'] = match_quality
            best['best_solution_index'] = i
            best['loc'], best['top_left'], best['bottom_right'] = find_center(kp1, kp2, matches[:num_matches], page_img.shape)
            best['matches'] = matches[:num_matches] 

    return best['loc'][0], best['loc'][1], best['best_solution_index']

@keyword
def find_icon_in_image(page_img_paths, icon_img_path, gray_scale=False, method='SIFT', num_matches=10):
    '''
    Finds a template in a list of pages (source file) and returns the location in the best match image as well as its index.
    '''
    return find_icon(page_img_paths, icon_img_path, gray_scale, method, num_matches)