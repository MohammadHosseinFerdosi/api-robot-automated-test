*** Settings ***
# Resource    parent.resource
Library    Browser


*** Keywords ***
Get Page URL
    RETURN    /auth/onboarding

Get Page Elements
    [Tags]    robot:private
    &{elements}    Create Dictionary
    ...    onboarding_message=//div[contains(text(),'خدمات مالی، متنوع و هوشمند!')]
    ...    onboarding_continue_button=//div[@class='buttons d-flex flex-row gap-medium ng-star-inserted']
    ...    otp_element=(//input[@type='tel'])

    RETURN    ${elements}

Should Be In Onboarding Page
    ${expected_path}    Get Page URL
    Wait Until Location Contains    ${expected_path}
    ${elements}    Get Page Elements
    Element Should Be Visible    ${elements['onboarding_message']}
