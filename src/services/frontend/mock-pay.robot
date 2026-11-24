*** Settings ***
# Library         Browser
Resource        services/frontend/browser-service.resource
Resource        apis/tgs/post-tickets-business.resource
Resource        apis/tgs/get-tickets.resource
Resource        apis/tgs/post-tickets-features-select.resource
Resource        pages/app/upg.resource
Resource        pages/app/ipg-mock.resource
Variables       data/payment/purchase/ipg_mock.yaml


*** Test Cases ***
Test
    Payment On The Mock PSP Through UPG
    ...    https://example.com/web-pay/tgs/v2:dcb316a83d51497388a90dffc06aa312
    ...    ${CHROME}
    ...    ${SUCCESS_PAY}


*** Keywords ***
Payment On The Mock PSP Through UPG
    [Documentation]    This Service Gets An ${URL} Such That This Field Was Returned By Select IPG Feature API In The Purchase Flow
    ...    Also Gets ${purchase_result} Such That This Field Can Be `${Success_Pay}` or `${Failed_Pay}
    ...    Also Gets ${browser_name} Such That This Field Can Be `${CHROME}` , or `${FIREFOX}` and `${EDGE}`
    [Arguments]    ${URL}    ${browser_name}    ${purchase_result}

    ${connecting_To_mock_psp}    Connect To Browser
    ...    ${URL}
    ...    browser=${browser_name}
    ...    is_remote=${False}
    ...    option=${None}
    ...    desired_capabilities=${None}
    ...    ff_profile_dir=${None}

    Maximize Browser Window

    Route On The psp
    Should Be On The Mock Page
    IF    '${purchase_result}'=='success'
        Success Payment
    ELSE IF    '${purchase_result}'=='fail'
        Failure Payment
    END
