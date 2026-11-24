*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem
Library     Collections
Library     library/image_utils.py

*** Keywords ***
Empty Captures
    [Documentation]    A utility to delete all captured images from the specified directory.
    ...
    ...    *Inputs:*
    ...    - `${captures_dir}`: (Optional) The directory path where captured images are stored. Defaults to `captures`.
    ...
    ...    *Behavior:*
    ...    - Removes the specified directory and all its contents recursively.
    [Arguments]    ${captures_dir}=captures
    Remove Directory    ${captures_dir}    recursive=True

Capture Images Vanilla
    [Documentation]    Captures the entire web page as multiple screenshots by scrolling and taking screenshots at each step.
    ...
    ...    *Inputs:*
    ...    - `${overlap_offset}`: (Optional) The overlap between consecutive screenshots in pixels. Defaults to `100`.
    ...    - `${num_scrolls}`: (Optional) The maximum number of scrolls to perform. Defaults to `20`.
    ...    - `${prefix}`: (Optional) The prefix for saved screenshot filenames. Defaults to `captured`.
    ...    - `${save_dir}`: (Optional) The directory to save the captured screenshots. Defaults to `captures`.
    ...    - `${resize}`: (Optional) Whether to resize the captured images. Defaults to `True`.
    ...    - `${resized_width}`: (Optional) The resized image width. Defaults to `2000`.
    ...    - `${resized_height}`: (Optional) The resized image height. Defaults to `1000`.
    ...    - `${default_sleep}`: (Optional) The time to wait after each scroll. Defaults to `3sec`.
    ...
    ...    *Behavior:*
    ...    - Scrolls the page in steps, capturing a screenshot at each step.
    ...    - If `${resize}` is `True`, resizes the images to a fixed width and height (2000x1000).
    ...    - Returns a dictionary containing the paths to the original and resized images, along with scaling factors.
    [Arguments]
    ...    ${overlap_offset}=100
    ...    ${num_scrolls}=20
    ...    ${prefix}=captured
    ...    ${save_dir}=captures
    ...    ${resize}=True
    ...    ${resized_width}=2000
    ...    ${resized_height}=1000
    ...    ${default_sleep}=3sec

    Sleep    time_=${default_sleep}    reason=Wait to make sure that body is generated!

    ${viewport_size}    Execute Javascript    return {width: window.innerWidth, height: window.innerHeight}
    ${document_size}    Execute Javascript
    ...    return {width: document.documentElement.scrollWidth, height: document.documentElement.scrollHeight}

    ${scroll_step}    Evaluate    ${viewport_size['height']} - ${overlap_offset}
    ${max_num_scrolls}    Evaluate    math.ceil(${document_size['height']} / ${scroll_step})
    IF    ${num_scrolls} > ${max_num_scrolls}
        ${num_scrolls}    Set Variable    ${max_num_scrolls}
    END

    ${current_scroll}    Set Variable    0
    ${image_paths}    Create List
    ${resized_image_paths}    Create List
    ${scale_list}    Create List

    FOR    ${i}    IN RANGE    ${num_scrolls}
        Execute Javascript    window.scrollTo(0, ${current_scroll});

        ${screenshot_path}    Set Variable    ${save_dir}/${prefix}_screenshot_${i}.png
        Append To List    ${image_paths}    ${ABSOLUTE_CAPTURE_PATH}/${screenshot_path}

        Capture Page Screenshot    ${screenshot_path}

        IF    ${resize}==True
            ${resized_path}    Set Variable    ${save_dir}/r_${prefix}_screenshot_${i}.png
            Append To List    ${resized_image_paths}    ${ABSOLUTE_CAPTURE_PATH}/${resized_path}
            ${scale_factor_height}    ${scale_factor_width}    Resize Image
            ...    image_path=${ABSOLUTE_CAPTURE_PATH}/${screenshot_path}
            ...    new_path=${ABSOLUTE_CAPTURE_PATH}/${resized_path}
            ...    new_w=${resized_width}
            ...    new_h=${resized_height}
            ${scale}    Create Dictionary
            ...    scale_factor_height=${scale_factor_height}
            ...    scale_factor_width=${scale_factor_width}
            Append To List    ${scale_list}    ${scale}
        END

        ${current_scroll}    Evaluate
        ...    min(${current_scroll} + ${scroll_step}, ${document_size['height']} - ${viewport_size['height']})
        Sleep    time_=${default_sleep}    reason=Wait for the rest of the page to move as well.
    END

    Execute Javascript    window.scrollTo(0, 0)
    ${result}    Create Dictionary
    ...    num_scrolls=${num_scrolls}
    ...    image_paths=${image_paths}
    ...    resized_image_paths=${resized_image_paths}
    ...    scale_list=${scale_list}
    RETURN    ${result}

Capture Images Platform Version 1
    [Documentation]    Captures the web page document as multiple screenshots, specifically designed for the Platform SuperApp UX/UI.
    ...
    ...    *Inputs:*
    ...    - `${scroll_step}`: (Optional) The length of each scroll in pixels. Defaults to `350`.
    ...    - `${num_scrolls}`: (Optional) The number of scrolls to perform. Defaults to `20`.
    ...    - `${div_config}`: (Optional) The ID of the scrollable div element. Defaults to `dpx-main-layout-body`.
    ...    - `${prefix}`: (Optional) The prefix for saved screenshot filenames. Defaults to `captured`.
    ...    - `${save_dir}`: (Optional) The directory to save the captured screenshots. Defaults to `captures`.
    ...    - `${resize}`: (Optional) Whether to resize the captured images. Defaults to `True`.
    ...    - `${resized_width}`: (Optional) The resized image width. Defaults to `2000`.
    ...    - `${resized_height}`: (Optional) The resized image height. Defaults to `1000`.
    ...    - `${default_sleep}`: (Optional) The time to wait after each scroll. Defaults to `3sec`.
    ...
    ...    *Behavior:*
    ...    - Scrolls the specified div element in steps, capturing a screenshot at each step.
    ...    - If `${resize}` is `True`, resizes the images to a fixed width and height (2000x1000).
    ...    - Returns a dictionary containing the paths to the original and resized images, along with scaling factors.
    [Arguments]
    ...    ${scroll_step}=350
    ...    ${num_scrolls}=20
    ...    ${div_config}=dpx-main-layout-body
    ...    ${prefix}=captured
    ...    ${save_dir}=captures
    ...    ${resize}=True
    ...    ${resized_width}=2000
    ...    ${resized_height}=1000
    ...    ${default_sleep}=3sec

    Sleep    time_=${default_sleep}    reason=Wait to make sure that body is generated!

    ${current_scroll}    Set Variable    0
    ${image_paths}    Create List
    ${resized_image_paths}    Create List
    ${scale_list}    Create List

    FOR    ${i}    IN RANGE    ${num_scrolls}
        Execute Javascript    document.getElementById('${div_config}').scrollTop += ${scroll_step}

        ${screenshot_path}    Set Variable    ${save_dir}/${prefix}_screenshot_${i}.png
        Append To List    ${image_paths}    ${ABSOLUTE_CAPTURE_PATH}/${screenshot_path}

        Capture Page Screenshot    ${screenshot_path}

        IF    ${resize}==True
            ${resized_path}    Set Variable    ${save_dir}/r_${prefix}_screenshot_${i}.png
            Append To List    ${resized_image_paths}    ${ABSOLUTE_CAPTURE_PATH}/${resized_path}
            ${scale_factor_height}    ${scale_factor_width}    Resize Image
            ...    image_path=${ABSOLUTE_CAPTURE_PATH}/${screenshot_path}
            ...    new_path=${ABSOLUTE_CAPTURE_PATH}/${resized_path}
            ...    new_w=${resized_width}
            ...    new_h=${resized_height}
            ${scale}    Create Dictionary
            ...    scale_factor_height=${scale_factor_height}
            ...    scale_factor_width=${scale_factor_width}
            Append To List    ${scale_list}    ${scale}
        END
        Sleep    time_=${default_sleep}    reason=Wait for the rest of the page to move as well.
    END

    ${height}    Execute Javascript    return document.getElementById('${div_config}').scrollHeight;
    Execute Javascript    document.getElementById('${div_config}').scrollTop += -${height}
    ${result}    Create Dictionary
    ...    num_scrolls=${num_scrolls}
    ...    image_paths=${image_paths}
    ...    resized_image_paths=${resized_image_paths}
    ...    scale_list=${scale_list}
    RETURN    ${result}

Capture Images Platform Version 2
    [Documentation]    Captures the web page document as multiple screenshots, specifically designed for the Topup pay SuperApp UX/UI.
    ...
    ...    *Inputs:*
    ...    - `${scroll_step}`: (Optional) The length of each scroll in pixels. Defaults to `350`.
    ...    - `${num_scrolls}`: (Optional) The number of scrolls to perform. Defaults to `20`.
    ...    - `${div_config}`: (Optional) The ID of the scrollable div element. Defaults to `dpx-main-layout-body`.
    ...    - `${prefix}`: (Optional) The prefix for saved screenshot filenames. Defaults to `captured`.
    ...    - `${save_dir}`: (Optional) The directory to save the captured screenshots. Defaults to `captures`.
    ...    - `${resize}`: (Optional) Whether to resize the captured images. Defaults to `True`.
    ...    - `${resized_width}`: (Optional) The resized image width. Defaults to `2000`.
    ...    - `${resized_height}`: (Optional) The resized image height. Defaults to `1000`.
    ...    - `${default_sleep}`: (Optional) The time to wait after each scroll. Defaults to `3sec`.
    ...
    ...    *Behavior:*
    ...    - Scrolls the specified div element in steps, capturing a screenshot at each step.
    ...    - If `${resize}` is `True`, resizes the images to a fixed width and height (2000x1000).
    ...    - Returns a dictionary containing the paths to the original and resized images, along with scaling factors.
    [Arguments]
    ...    ${scroll_step}=350
    ...    ${num_scrolls}=20
    ...    ${div_config}=.tgs-container.d-flex.flex-column.flex-grow.h-100.px-big.pt-big
    ...    ${prefix}=captured
    ...    ${save_dir}=captures
    ...    ${resize}=True
    ...    ${resized_width}=2000
    ...    ${resized_height}=1000
    ...    ${default_sleep}=3sec

    Sleep    time_=${default_sleep}    reason=Wait to make sure that body is generated!

    ${current_scroll}    Set Variable    0
    ${image_paths}    Create List
    ${resized_image_paths}    Create List
    ${scale_list}    Create List

    FOR    ${i}    IN RANGE    ${num_scrolls}
        Execute Javascript    document.querySelector('${div_config}').scrollTo(0,${scroll_step})
        ${scroll_step}    Evaluate    int(${scroll_step})+int(${scroll_step})

        ${screenshot_path}    Set Variable    ${save_dir}/${prefix}_screenshot_${i}.png
        Append To List    ${image_paths}    ${ABSOLUTE_CAPTURE_PATH}/${screenshot_path}

        Capture Page Screenshot    ${screenshot_path}

        IF    ${resize}==True
            ${resized_path}    Set Variable    ${save_dir}/r_${prefix}_screenshot_${i}.png
            Append To List    ${resized_image_paths}    ${ABSOLUTE_CAPTURE_PATH}/${resized_path}
            ${scale_factor_height}    ${scale_factor_width}    Resize Image
            ...    image_path=${ABSOLUTE_CAPTURE_PATH}/${screenshot_path}
            ...    new_path=${ABSOLUTE_CAPTURE_PATH}/${resized_path}
            ...    new_w=${resized_width}
            ...    new_h=${resized_height}
            ${scale}    Create Dictionary
            ...    scale_factor_height=${scale_factor_height}
            ...    scale_factor_width=${scale_factor_width}
            Append To List    ${scale_list}    ${scale}
        END
        Sleep    time_=${default_sleep}    reason=Wait for the rest of the page to move as well.
    END
    Execute Javascript    document.querySelector('${div_config}').scrollTo(0,0)
    ${result}    Create Dictionary
    ...    num_scrolls=${num_scrolls}
    ...    image_paths=${image_paths}
    ...    resized_image_paths=${resized_image_paths}
    ...    scale_list=${scale_list}
    RETURN    ${result}
