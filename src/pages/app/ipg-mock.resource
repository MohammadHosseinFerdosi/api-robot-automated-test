*** Settings ***
Library     String
Resource    parent.resource
Variables    config/environment-stage.yaml


*** Keywords ***
Get Page URL
    RETURN    ${IPG_MOCK_PATH}

Get Page Elements
    &{elements}    Create Dictionary
    ...    set_ipg_status=//h1[normalize-space()='Set Ipg Status']
    ...    submit&redirect=//button[@type='submit']
    ...    status_btn=//select[@id='status']
    ...    success_result=//*[@id="status"]/option[1]
    ...    failure_result=//*[@id="status"]/option[2]
    RETURN    ${elements}

Should Be On The Mock Page
    ${elements}    Get Page Elements
    Location Should Contain    ${IPG_MOCK_PATH}
    Wait Until Page Contains Element    ${elements['set_ipg_status']}    timeout=60s

Success Payment
    ${elements}    Get Page Elements
    Wait Until Element Is Enabled    ${elements['status_btn']}
    Click Element    ${elements['status_btn']}
    Wait Until Element Is Visible    ${elements['success_result']}
    Click Element    ${elements['success_result']}
    Click Button    ${elements['submit&redirect']}

Failure Payment
    ${elements}    Get Page Elements
    Wait Until Element Is Enabled    ${elements['status_btn']}
    Click Element    ${elements['statu_btn']}
    Wait Until Element Is Visible    ${elements['failure_result']}
    Click Element    ${elements['failure_result']}
    Click Button    ${elements['submit&redirect']}

# Extract Result Trace Id        
#     Wait Until Location Contains    traceId    60s
#     Page Should Contain Element    