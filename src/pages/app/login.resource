*** Settings ***
Library         Browser
Variables    data/CONSTANTS.yaml


*** Keywords ***
Get Page URL
    RETURN    /auth/login

Get Page Elements
    [Tags]    robot:private
    &{elements}    Create Dictionary
    ...    cell_number=css:input[type='tel']
    ...    accept_button=css:span[class='ng-star-inserted']
    ...    otp_element=(//input[@type='tel'])

    RETURN    ${elements}

Should Be In Login Page
    ${expected_path}    Get Page URL
    Wait Until Location Contains    ${expected_path}
    ${elements}    Get Page Elements
    Element Should Be Visible    ${elements['accept_button']}
