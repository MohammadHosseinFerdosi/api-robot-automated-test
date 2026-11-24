*** Settings ***
Resource    services/AI/capture-image.resource
Library     String
Library     library/find_icon.py


*** Keywords ***
Scroll To Page Vanilla
    [Documentation]    Scrolls the page to a specific position based on the given index.
    ...
    ...    *Inputs:*
    ...    - `${index}`: The index of the scroll step to reach.
    ...    - `${overlap_offset}`: (Optional) The overlap between consecutive scrolls in pixels. Defaults to `100`.
    ...    - `${default_sleep}`: (Optional) The time to wait after each scroll. Defaults to `3sec`.
    ...
    ...    *Behavior:*
    ...    - Scrolls the page in steps, ensuring the browser is at the correct position for interacting with elements.
    [Arguments]
    ...    ${index}
    ...    ${overlap_offset}=100
    ...    ${default_sleep}=3sec
    [Tags]    robot:private

    ${viewport_size}    Execute Javascript    return {width: window.innerWidth, height: window.innerHeight}
    ${document_size}    Execute Javascript
    ...    return {width: document.documentElement.scrollWidth, height: document.documentElement.scrollHeight}

    ${scroll_step}    Evaluate    ${viewport_size['height']} - ${overlap_offset}
    ${current_scroll}    Set Variable    0
    ${range}    Evaluate    ${index}+1

    FOR    ${i}    IN RANGE    ${range}
        Execute Javascript    window.scrollTo(0, ${current_scroll});
        ${current_scroll}    Evaluate
        ...    min(${current_scroll} + ${scroll_step}, ${document_size['height']} - ${viewport_size['height']})
        Sleep    time_=${default_sleep}    reason=Wait for the rest of the page to move as well.
    END

Scroll To Page Platform Version 1
    [Documentation]    Scrolls a specific div element to a position based on the given index.
    ...
    ...    *Inputs:*
    ...    - `${index}`: The index of the scroll step to reach.
    ...    - `${scroll_step}`: (Optional) The length of each scroll in pixels. Defaults to `350`.
    ...    - `${div_config}`: (Optional) The ID of the scrollable div element. Defaults to `dpx-main-layout-body`.
    ...    - `${default_sleep}`: (Optional) The time to wait after each scroll. Defaults to `3sec`.
    ...
    ...    *Behavior:*
    ...    - Scrolls the specified div element in steps, ensuring the browser is at the correct position for interacting with elements.
    [Arguments]
    ...    ${index}
    ...    ${scroll_step}=350
    ...    ${div_config}=dpx-main-layout-body
    ...    ${default_sleep}=3sec
    [Tags]    robot:private

    IF    '${index}'!='0'
        FOR    ${i}    IN RANGE    ${index}
            Execute Javascript    document.getElementById('${div_config}').scrollTop += ${scroll_step}
            Sleep    time_=${default_sleep}    reason=Wait for the rest of the page to move as well.
        END
    END

Scroll To Page Platform Version 2
    [Documentation]    Scrolls a specific div element to a position based on the given index.
    ...
    ...    *Inputs:*
    ...    - `${index}`: The index of the scroll step to reach.
    ...    - `${scroll_step}`: (Optional) The length of each scroll in pixels. Defaults to `350`.
    ...    - `${div_config}`: (Optional) The ID of the scrollable div element. Defaults to `dpx-main-layout-body`.
    ...    - `${default_sleep}`: (Optional) The time to wait after each scroll. Defaults to `3sec`.
    ...
    ...    *Behavior:*
    ...    - Scrolls the specified div element in steps, ensuring the browser is at the correct position for interacting with elements.
    [Arguments]
    ...    ${index}
    ...    ${scroll_step}=350
    ...    ${div_config}=.tgs-container.d-flex.flex-column.flex-grow.h-100.px-big.pt-big
    ...    ${default_sleep}=3sec
    [Tags]    robot:private

    IF    '${index}'!='0'
        FOR    ${i}    IN RANGE    ${index}
            Execute Javascript    document.querySelector('${div_config}').scrollTo(0,${scroll_step})
            ${scroll_step}    Evaluate    int(${scroll_step})+int(${scroll_step})
            Sleep    time_=${default_sleep}    reason=Wait for the rest of the page to move as well.
        END
    END

Find Icon
    [Documentation]    Finds the best location of an icon within the captured screenshots.
    ...
    ...    *Inputs:*
    ...    - `${image_paths}`: List of paths to the captured screenshots.
    ...    - `${icon_path}`: Path to the icon image to search for.
    ...    - `${scale_list}`: List of scaling factors for the resized images.
    ...    - `${version}`: (Optional) The version of the scroll method used (`vanilla` or `platform` or `platform-2`). Defaults to `vanilla`.
    ...    - `${gray_scale}`: (Optional) Whether to convert images to grayscale before searching. Defaults to `False`.
    ...    - `${method}`: (Optional) The template matching method to use. Defaults to `SIFT` (other option is `ORB`).
    ...    - `${num_matches}`: (Optional) The number of matches to consider an icon found. Defaults to `10`.
    ...
    ...    *Behavior:*
    ...    - Searches for the icon in the captured screenshots and returns its coordinates and the index of the image where it was found.
    [Arguments]
    ...    ${image_paths}
    ...    ${icon_path}
    ...    ${scale_list}
    ...    ${version}=vanilla
    ...    ${gray_scale}=False
    ...    ${method}=SIFT
    ...    ${num_matches}=10
    [Tags]    robot:private

    ${x}    ${y}    ${index}    Find Icon In Image
    ...    page_img_paths=${image_paths}
    ...    icon_img_path=${icon_path}
    ...    gray_scale=${gray_scale}
    ...    method=${method}
    ...    num_matches=${num_matches}

    ${scale}    Set Variable    ${scale_list}[${index}]
    ${scale_height}    Set Variable    ${scale['scale_factor_height']}
    ${scale_width}    Set Variable    ${scale['scale_factor_width']}

    ${scaled_x}    ${scaled_y}    Rescale Position
    ...    scale_h=${scale_height}
    ...    scale_w=${scale_width}
    ...    x=${x}
    ...    y=${y}

    ${device_pixel_ratio}    Execute Javascript    return window.devicePixelRatio
    ${scroll_x}    Execute Javascript    return window.scrollX
    ${scroll_y}    Execute Javascript    return window.scrollY

    ${actual_x}    Evaluate    (${scaled_x} / ${device_pixel_ratio}) + ${scroll_x}
    ${actual_y}    Evaluate    (${scaled_y} / ${device_pixel_ratio}) + ${scroll_y}

    RETURN    ${actual_x}    ${actual_y}    ${index}

Click At Coordinates
    [Documentation]    Clicks at the specified coordinates on the page.
    ...
    ...    *Inputs:*
    ...    - `${location_x}`: The X-coordinate to click.
    ...    - `${location_y}`: The Y-coordinate to click.
    ...    - `${index}`: The index of the scroll step to reach before clicking.
    ...    - `${debug}`: (Optional) Whether to display a red dot at the clicked location for debugging. Defaults to `True`.
    ...    - `${version}`: (Optional) The version of the scroll method used (`vanilla` or `platform` or `platform-2`). Defaults to `vanilla`.
    ...    - `${overlap_offset}`: (Optional) The overlap between consecutive scrolls in pixels. Defaults to `100`.
    ...    - `${scroll_step}`: (Optional) The length of each scroll in pixels. Defaults to `350`.
    ...    - `${default_sleep}`: (Optional) The time to wait after each scroll. Defaults to `3sec`.
    ...    - `${div_config}`: (Optional) The ID of the scrollable div element. Defaults to `dpx-main-layout-body`.
    ...
    ...    *Behavior:*
    ...    - Scrolls to the correct position and clicks at the specified coordinates.
    ...    - If `${debug}` is `True`, a red dot is displayed at the clicked location.
    [Arguments]
    ...    ${location_x}
    ...    ${location_y}
    ...    ${index}
    ...    ${debug}=True
    ...    ${version}=vanilla
    ...    ${overlap_offset}=100
    ...    ${scroll_step}=350
    ...    ${default_sleep}=3sec
    ...    ${div_config}=dpx-main-layout-body
    [Tags]    robot:private

    IF    '${version}'=='platform-1'
        Scroll To Page Platform Version 1
        ...    index=${index}
        ...    scroll_step=${scroll_step}
        ...    div_config=${div_config}
        ...    default_sleep=${default_sleep}
    ELSE IF    '${version}'=='platform-2'
        Scroll To Page Platform Version 2
        ...    index=${index}
        ...    scroll_step=${scroll_step}
        ...    div_config=.tgs-container.d-flex.flex-column.flex-grow.h-100.px-big.pt-big
        ...    default_sleep=${default_sleep}
    ELSE
        Scroll To Page Vanilla    index=${index}    overlap_offset=${overlap_offset}    default_sleep=${default_sleep}
    END

    IF    ${debug}==True
        Execute Javascript
        ...    var dot = document.createElement('div'); dot.style.width = '10px'; dot.style.height = '10px'; dot.style.backgroundColor = 'red'; dot.style.borderRadius = '50%'; dot.style.position = 'absolute'; dot.style.left = '${location_x}px'; dot.style.top = '${location_y}px'; dot.style.zIndex = '9999'; document.body.appendChild(dot);
    END

    Execute Javascript
    ...    var evt = new MouseEvent('click', {clientX: ${location_x}, clientY: ${location_y}, bubbles: true, cancelable: true}); document.elementFromPoint(${location_x}, ${location_y}).dispatchEvent(evt);

Find And Click
    [Documentation]    Combines capturing screenshots, finding an icon, and clicking on it.
    ...
    ...    *Inputs:*
    ...    - `${icon_path}`: Path to the icon image to search for.
    ...    - `${debug}`: (Optional) Whether to display a red dot at the clicked location for debugging. Defaults to `True`.
    ...    - `${overlap_offset}`: (Optional) The overlap between consecutive scrolls in pixels. Defaults to `100`.
    ...    - `${scroll_step}`: (Optional) The length of each scroll in pixels. Defaults to `350`.
    ...    - `${num_scrolls}`: (Optional) The number of scrolls to perform. Defaults to `20`.
    ...    - `${div_config}`: (Optional) The ID of the scrollable div element. Defaults to `dpx-main-layout-body`.
    ...    - `${prefix}`: (Optional) The prefix for saved screenshot filenames. Defaults to an empty string.
    ...    - `${save_dir}`: (Optional) The directory to save the captured screenshots. Defaults to `captures`.
    ...    - `${resize}`: (Optional) Whether to resize the captured images. Defaults to `True`.
    ...    - `${gray_scale}`: (Optional) Whether to convert images to grayscale before searching. Defaults to `False`.
    ...    - `${method}`: (Optional) The template matching method to use. Defaults to `SIFT` (other method is `ORB`).
    ...    - `${num_matches}`: (Optional) The number of matches to consider an icon found. Defaults to `10`.
    ...    - `${version}`: (Optional) The version of the scroll method used (`vanilla` or `platform` or `platform-2`). Defaults to `vanilla`.
    ...    - `${resized_width}`: (Optional) The width to resize images to. Defaults to `2000`.
    ...    - `${resized_height}`: (Optional) The height to resize images to. Defaults to `1000`.
    ...    - `${default_sleep}`: (Optional) The time to wait after each scroll. Defaults to `3sec`.
    ...
    ...    *Behavior:*
    ...    - Captures screenshots, finds the icon, and clicks on it.
    ...    - Returns the coordinates and index of the found icon.
    [Arguments]
    ...    ${icon_path}
    ...    ${debug}=True
    ...    ${overlap_offset}=100
    ...    ${scroll_step}=350
    ...    ${num_scrolls}=20
    ...    ${div_config}=dpx-main-layout-body
    ...    ${prefix}=${EMPTY}
    ...    ${save_dir}=captures
    ...    ${resize}=True
    ...    ${gray_scale}=False
    ...    ${method}=SIFT
    ...    ${num_matches}=10
    ...    ${version}=vanilla
    ...    ${resized_width}=2000
    ...    ${resized_height}=1000
    ...    ${default_sleep}=3sec

    IF    '${prefix}'=='${EMPTY}'
        ${prefix}    Generate Random String    length=4    chars=ABCDEFGHIJKLMNOPQRSTUVWXYZ
    END

    IF    '${version}'=='platform-1'
        ${result}    Capture Images Platform Version 1
        ...    scroll_step=${scroll_step}
        ...    num_scrolls=${num_scrolls}
        ...    div_config=${div_config}
        ...    prefix=${prefix}
        ...    save_dir=${save_dir}
        ...    resize=${resize}
        ...    resized_width=${resized_width}
        ...    resized_height=${resized_height}
        ...    default_sleep=${default_sleep}
    ELSE IF    '${version}'=='platform-2'
        ${result}    Capture Images Platform Version 2
        ...    scroll_step=${overlap_offset}
        ...    div_config=${div_config}
        ...    num_scrolls=${num_scrolls}
        ...    prefix=${prefix}
        ...    save_dir=${save_dir}
        ...    resize=${resize}
        ...    resized_width=${resized_width}
        ...    resized_height=${resized_height}
        ...    default_sleep=${default_sleep}
    ELSE
        ${result}    Capture Images Vanilla
        ...    overlap_offset=${overlap_offset}
        ...    num_scrolls=${num_scrolls}
        ...    prefix=${prefix}
        ...    save_dir=${save_dir}
        ...    resize=${resize}
        ...    resized_width=${resized_width}
        ...    resized_height=${resized_height}
        ...    default_sleep=${default_sleep}
    END

    ${num_scrolls}    Set Variable    ${result['num_scrolls']}
    ${image_paths}    Set Variable    ${result['image_paths']}
    ${resized_image_paths}    Set Variable    ${result['resized_image_paths']}
    ${scale_list}    Set Variable    ${result['scale_list']}

    IF    ${resize}
        ${actual_x}    ${actual_y}    ${index}    Find Icon
        ...    image_paths=${resized_image_paths}
        ...    icon_path=${icon_path}
        ...    scale_list=${scale_list}
        ...    version=${version}
        ...    gray_scale=${gray_scale}
        ...    method=${method}
        ...    num_matches=${num_matches}
    ELSE
        ${actual_x}    ${actual_y}    ${index}    Find Icon
        ...    image_paths=${image_paths}
        ...    icon_path=${icon_path}
        ...    scale_list=${scale_list}
        ...    version=${version}
        ...    gray_scale=${gray_scale}
        ...    method=${method}
        ...    num_matches=${num_matches}
    END

    Click At Coordinates
    ...    location_x=${actual_x}
    ...    location_y=${actual_y}
    ...    index=${index}
    ...    debug=${debug}
    ...    version=${version}
    ...    overlap_offset=${overlap_offset}
    ...    scroll_step=${scroll_step}
    ...    default_sleep=${default_sleep}

    IF    '${debug}'=='False'    Empty Captures    captures_dir=${save_dir}

Find And Click And Insert
    [Documentation]    Combines the find and click utility with an inserted value.
    ...
    ...    *Inputs:*
    ...    - `${input}`: The input to be inserted
    ...    - `${icon_path}`: Path to the icon image to search for.
    ...    - `${input_delay}`: (Optional) If there is an input delay between pressing the buttons.
    ...    - `${debug}`: (Optional) Whether to display a red dot at the clicked location for debugging. Defaults to `True`.
    ...    - `${overlap_offset}`: (Optional) The overlap between consecutive scrolls in pixels. Defaults to `100`.
    ...    - `${scroll_step}`: (Optional) The length of each scroll in pixels. Defaults to `350`.
    ...    - `${num_scrolls}`: (Optional) The number of scrolls to perform. Defaults to `20`.
    ...    - `${div_config}`: (Optional) The ID of the scrollable div element. Defaults to `dpx-main-layout-body`.
    ...    - `${prefix}`: (Optional) The prefix for saved screenshot filenames. Defaults to an empty string.
    ...    - `${save_dir}`: (Optional) The directory to save the captured screenshots. Defaults to `captures`.
    ...    - `${resize}`: (Optional) Whether to resize the captured images. Defaults to `True`.
    ...    - `${gray_scale}`: (Optional) Whether to convert images to grayscale before searching. Defaults to `False`.
    ...    - `${method}`: (Optional) The template matching method to use. Defaults to `SIFT` (other method is `ORB`).
    ...    - `${num_matches}`: (Optional) The number of matches to consider an icon found. Defaults to `10`.
    ...    - `${version}`: (Optional) The version of the scroll method used (`vanilla` or `platform-1` or `platform-2`). Defaults to `vanilla`.
    ...    - `${resized_width}`: (Optional) The width to resize images to. Defaults to `2000`.
    ...    - `${resized_height}`: (Optional) The height to resize images to. Defaults to `1000`.
    ...    - `${default_sleep}`: (Optional) The time to wait after each scroll. Defaults to `3sec`.
    ...
    ...    *Behavior:*
    ...    - Captures screenshots, finds the icon, and clicks on it and then inserts the input
    ...    - Returns the coordinates and index of the found icon.
    [Arguments]
    ...    ${input}
    ...    ${icon_path}
    ...    ${input_delay}=3sec
    ...    ${debug}=True
    ...    ${overlap_offset}=100
    ...    ${scroll_step}=350
    ...    ${num_scrolls}=20
    ...    ${div_config}=dpx-main-layout-body
    ...    ${prefix}=${EMPTY}
    ...    ${save_dir}=captures
    ...    ${resize}=True
    ...    ${gray_scale}=False
    ...    ${method}=SIFT
    ...    ${num_matches}=10
    ...    ${version}=vanilla
    ...    ${resized_width}=2000
    ...    ${resized_height}=1000
    ...    ${default_sleep}=3sec

    Find And Click
    ...    icon_path=${icon_path}
    ...    debug=${debug}
    ...    overlap_offset=${overlap_offset}
    ...    scroll_step=${scroll_step}
    ...    num_scrolls=${num_scrolls}
    ...    div_config=${div_config}
    ...    prefix=${prefix}
    ...    save_dir=${save_dir}
    ...    resize=${resize}
    ...    gray_scale=${gray_scale}
    ...    method=${method}
    ...    num_matches=${num_matches}
    ...    version=${version}
    ...    resized_width=${resized_width}
    ...    resized_height=${resized_height}
    ...    default_sleep=${default_sleep}

    IF    '${input_delay}'=='${EMPTY}'
        Press Keys    None    ${input}   
        RETURN
    END
    ${length}    Get Length    ${input}
    FOR    ${i}    IN RANGE    ${0}    ${length}    ${1}
        Press Keys    None    ${input}[${i}]
        Sleep    ${input_delay}
    END