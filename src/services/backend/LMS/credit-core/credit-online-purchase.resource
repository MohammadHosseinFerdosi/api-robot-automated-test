*** Settings ***
Library         library/faker_utils.py    WITH NAME    FakerLibrary
Library         RequestsLibrary
Library         Collections
Library         String
Library         Browser
Library         DateTime
Resource        services/db/mongo-db-service.resource
Resource        apis/lms/credit-core/post-credit-purchases-ticket.resource
Resource        apis/lms/credit-core/get-credit-purchases-prepare.resource
Resource        apis/lms/credit-core/get-credit-purchases-detail.resource
Resource        apis/lms/credit-core/get-credit-purchases-route-info.resource
Resource        apis/lms/credit-core/get-credit-purchases-pay.resource
Resource        apis/lms/credit-core/post-credit-purchases-verify.resource
Resource        apis/lms/credit-core/post-credit-purchases-deliver.resource
Resource        apis/lms/credit-core/post-purchases-coupon-validate.resource
Resource        apis/purchase-mng/moke-pay/mock-ipg-result.resource
Resource        apis/purchase-mng/moke-pay/mock-ipg-result-psp.resource
Variables       data/lms/purchase-bnpl.yaml


*** Keywords ***
Get ticket
    [Documentation]    An intermediatory keyword that simply calls the API and retrieve the relevant information from the API
    [Tags]    robot:private
    [Arguments]
    ...    ${type}
    ...    ${amount}
    ...    ${cell_number}
    ...    ${credit_id}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${channel}=${CHANNEL.UPG}
    ...    ${provider_id}=${EMPTY}
    ...    ${redirect_url}=https://example.com/
    ...    ${seller_id}=default
    ...    ${supplier_id}=default
    ...    ${product_code}=default
    ...    ${brand}=default
    ...    ${count}=1
    ...    ${category_id}=default
    ...    ${product_type}=${PRODUCT_TYPE.CONSUMPTIONGOODS}
    ...    ${basket_id}=${EMPTY}
    ...    ${user_id}=${COMPANY_USER_ID}
    ...    ${cheque_eligibility}=true

    IF    '${provider_id}'=='${EMPTY}'
        ${provider_id}    Generate random string    16    1234567890
    END
    IF    '${basket_id}'=='${EMPTY}'
        ${basket_id}    Generate random string    6    1234567890
    END

    ${response}    POST Credit Purchases Ticket
    ...    api_call_side=${api_call_side}
    ...    type=${type}
    ...    channel=${channel}
    ...    amount=${amount}
    ...    cell_number=${cell_number}
    ...    credit_id=${credit_id}
    ...    provider_id=${provider_id}
    ...    redirect_url=${redirect_url}
    ...    seller_id=${seller_id}
    ...    supplier_id=${supplier_id}
    ...    product_code=${product_code}
    ...    brand=${brand}
    ...    count=${count}
    ...    category_id=${category_id}
    ...    product_type=${product_type}
    ...    basket_id=${basket_id}
    ...    user_id=${user_id}
    ...    cheque_eligible=${cheque_eligibility}

    ${status_code}    Set Variable    ${response['status_code']}
    ${body}    Set Variable    ${response['body']}
    IF    '${status_code}'=='200'
        ${ticket}    Set Variable    ${body['ticket']}
        ${tracking_code}    Find The Purchase Tracking Code    ticket=${ticket}
        RETURN    ${ticket}    ${tracking_code}
    ELSE
        Fail    msg=Ticket Generation failed, please investigate if that was not intended!
    END

Purchase credit prepare
    [Documentation]    An intermediatory keyword that simply calls the API and retrieve the relevant information from the API
    [Tags]    robot:private
    [Arguments]
    ...    ${user_id}
    ...    ${credit_id}
    ...    ${ticket}
    ...    ${amount}
    ...    ${credit_amount}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${fp_business_id}=${FUND_PROVIDER_BUSINESS_ID.PLATFORM}
    ...    ${coupon_code}=${EMPTY}

    ${response}    GET Credit Purchases Prepare
    ...    api_call_side=${api_call_side}
    ...    user_id=${user_id}
    ...    fp_business_id=${fp_business_id}
    ...    credit_id=${credit_id}
    ...    ticket=${ticket}
    ...    amount=${amount}
    ...    credit_amount=${credit_amount}
    ...    coupon_code=${coupon_code}

    ${status_code}    Set Variable    ${response['status_code']}
    IF    '${coupon_code}' != '${EMPTY}'
        Should Be Equal As Integers    ${response['status_code']}    200
    ELSE
        Should Be Equal As Strings
        ...    ${status_code}
        ...    200
        ...    msg=Preparing the purchase has failed, please investigate if that was not intended!
    END

Purchase route info
    [Documentation]    An intermediatory keyword that simply calls the API and retrieve the relevant information from the API
    [Tags]    robot:private
    [Arguments]
    ...    ${ticket}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}

    ${response}    GET Credit Purchases Route Info
    ...    ${MICROSERVICE_SIDE}
    ...    ${ticket}

    ${status_code}    Set Variable    ${response['status_code']}

    Should Be Equal As Strings
    ...    ${status_code}
    ...    200
    ...    msg=Getting the Route Info for the purchase has failed, please investigate if that was not intended!

Find The Purchase Tracking Code
    [Arguments]    ${ticket}=${ticket}

    ${filter_query}    Create Dictionary    ticket=${ticket}

    ${active_account}    Mongo Db Find    credit_mng_db    purchases    ${filter_query}
    @{records}    Get From Dictionary    ${active_account}    body
    ${tracking_code}    Set Variable    ${${records[0]['trackingCode']}}
    RETURN    ${tracking_code}

Purchase credit pay
    [Documentation]    An intermediatory keyword that simply calls the API and retrieve the relevant information from the API
    [Tags]    robot:private
    [Arguments]
    ...    ${ticket}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}

    ${pay_result}    GET Credit Purchases Pay
    ...    api_call_side=${api_call_side}
    ...    ticket=${ticket}
    Set Test Variable    ${pay_result}
    ${status_code}    Set Variable    ${pay_result['status_code']}

    Should Be Equal As Strings
    ...    ${status_code}
    ...    200
    ...    msg=Paying the purchase has failed, please investigate if that was not intended!

Purchase Verify
    [Documentation]    An intermediatory keyword that simply calls the API and retrieve the relevant information from the API
    [Tags]    robot:private
    [Arguments]
    ...    ${type}
    ...    ${tracking_code}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${user_id}=${COMPANY_USER_ID}

    ${response}    POST Credit Purchases Verify
    ...    api_call_side=${api_call_side}
    ...    tracking_code=${tracking_code}
    ...    type=${type}
    ...    user_id=${user_id}

    ${status_code}    Set Variable    ${response['status_code']}
    IF    '${status_code}'!='200'
        Fail    msg=Response Body: ${response['body']}
    END

Purchase Deliver
    [Documentation]    An intermediatory keyword that simply calls the API and retrieve the relevant information from the API
    [Tags]    robot:private
    [Arguments]
    ...    ${tracking_code}
    ...    ${type}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${delivery_date}=${EMPTY}
    ...    ${invoice_number}=${EMPTY}
    ...    ${products}=${EMPTY}
    ...    ${user_id}=${COMPANY_USER_ID}

    IF    '${delivery_date}'=='${EMPTY}'
        ${delivery_date}    Get Time    epoch    now
    END
    IF    '${invoice_number}'=='${EMPTY}'
        ${invoice_number}    Generate Random String    7    1234567890
    END
    IF    '${products}'=='${EMPTY}'
        ${products}    Create List    product-1
    END

    ${response}    POST Credit Purchases Deliver
    ...    api_call_side=${api_call_side}
    ...    delivery_date=${delivery_date}
    ...    invoice_number=${invoice_number}
    ...    tracking_code=${tracking_code}
    ...    type=${type}
    ...    products=${products}
    ...    user_id=${user_id}

    ${status_code}    Set Variable    ${response['status_code']}

    ${status_code}    Set Variable    ${response['status_code']}
    IF    '${status_code}'!='200'
        Fail    msg=Response Body: ${response['body']}
    END

Perform A Complete Online Credit Purchase
    [Documentation]
    ...    Performs a complete purchase that is only paid via the **Credit**.
    ...
    ...    Can Skip (List) Some steps: The available steps are : [`ticket`, `prepare`, `route_info`, `credit_pay`, `verify`, and `deliver`]
    [Arguments]
    ...    ${type}
    ...    ${amount}
    ...    ${cell_number}
    ...    ${credit_id}
    ...    ${user_id}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${channel}=${CHANNEL.UPG}
    ...    ${provider_id}=${EMPTY}
    ...    ${redirect_url}=https://example.com/
    ...    ${seller_id}=default
    ...    ${supplier_id}=default
    ...    ${product_code}=default
    ...    ${brand}=default
    ...    ${count}=1
    ...    ${category_id}=default
    ...    ${product_type}=${PRODUCT_TYPE.CONSUMPTIONGOODS}
    ...    ${basket_id}=${EMPTY}
    ...    ${business_id}=${COMPANY_USER_ID}
    ...    ${fp_business_id}=${FUND_PROVIDER_BUSINESS_ID.PLATFORM}
    ...    ${delivery_date}=${EMPTY}
    ...    ${invoice_number}=${EMPTY}
    ...    ${products}=${EMPTY}
    ...    ${cheque_eligibility}=true
    ...    ${successful_purchase}=${TRUE}
    ...    ${has_cash_pay}=${False}
    ...    ${coupon_code}=${EMPTY}
    ...    ${skip}=@{EMPTY}

    ${skip_ticket}    Evaluate    'ticket' in ${skip}
    ${skip_prepare}    Evaluate    'prepare' in ${skip}
    ${skip_route_info}    Evaluate    'route_info' in ${skip}
    ${skip_credit_pay}    Evaluate    'credit_pay' in ${skip}
    ${skip_verify}    Evaluate    'verify' in ${skip}
    ${skip_deliver}    Evaluate    'deliver' in ${skip}

    IF    '${skip_ticket}'=='False'
        ${ticket}    ${tracking_code}    Get ticket
        ...    type=${type}
        ...    amount=${amount}
        ...    cell_number=${cell_number}
        ...    credit_id=${credit_id}
        ...    api_call_side=${api_call_side}
        ...    channel=${channel}
        ...    provider_id=${provider_id}
        ...    redirect_url=${redirect_url}
        ...    seller_id=${seller_id}
        ...    supplier_id=${supplier_id}
        ...    product_code=${product_code}
        ...    brand=${brand}
        ...    count=${count}
        ...    category_id=${category_id}
        ...    product_type=${product_type}
        ...    basket_id=${basket_id}
        ...    user_id=${business_id}
        ...    cheque_eligibility=${cheque_eligibility}
    END

    IF    '${skip_prepare}'=='False'
        ${purchase_detail}    GET Credit Purchases Detail
        ...    api_call_side=${api_call_side}
        ...    user_id=${user_id}
        ...    FUND_PROVIDER_BUSINESS_ID=${fp_business_id}
        ...    ticket=${ticket}
        ...    credit_id=${credit_id}
        ...    version=${PLATFORM_VERSION_2026}
        ...    coupon_code=${coupon_code}
        Set Test Variable    ${credit_amount}    ${purchase_detail}[body][creditDetail][creditAmount]
        Purchase credit prepare
        ...    user_id=${user_id}
        ...    credit_id=${credit_id}
        ...    ticket=${ticket}
        ...    amount=${amount}
        ...    credit_amount=${credit_amount}
        ...    api_call_side=${api_call_side}
        ...    fp_business_id=${fp_business_id}
        ...    coupon_code=${coupon_code}
    END

    IF    '${skip_route_info}'=='False'
        Purchase route info    ticket=${ticket}    api_call_side=${api_call_side}
    END

    IF    '${skip_credit_pay}'=='False'
        Purchase credit pay    ticket=${ticket}    api_call_side=${api_call_side}
    END
    IF    '${has_cash_pay}'=='True'
        Set Test Variable    ${BASE_URL}    ${pay_result}[body][url]
        Set Test Variable    ${BTN_NAME}    Submit & Redirect
        Set Test Variable    ${BTN_LOC}    role=button[name="${BTN_NAME}"]
        Set Test Variable    ${NAV_TIMEOUT}    30s
        Set Test Variable    ${VISIBLE_TO}    10s
        Open Browser Session
        New Page    ${BASE_URL}
        Click And Wait (Robust, No-Promise)
        Assert Landed    url=example.com/
        Take Screenshot On Failure
        Close Browser Session
    END
    IF    '${skip_verify}'=='False'
        Purchase Verify
        ...    type=${type}
        ...    tracking_code=${tracking_code}
        ...    api_call_side=${api_call_side}
        ...    user_id=${business_id}
    END

    IF    '${skip_deliver}'=='False'
        ${status_code_deliver}    Purchase Deliver
        ...    tracking_code=${tracking_code}
        ...    type=${type}
        ...    api_call_side=${api_call_side}
        ...    delivery_date=${delivery_date}
        ...    invoice_number=${invoice_number}
        ...    products=${products}
        ...    user_id=${business_id}
    END

    ${tracking_code}    Convert To String    item=${tracking_code}

    RETURN    ${ticket}    ${tracking_code}

Open Browser Session
    New Browser    chromium    headless=${True}
    New Context
    New Page    about:blank

Close Browser Session
    Close Browser

Take Screenshot On Failure
    Run Keyword And Ignore Error    Take Screenshot    fullPage=${True}

Click And Wait (Robust, No-Promise)
    Wait For Elements State    ${BTN_LOC}    visible    ${VISIBLE_TO}
    Wait For Elements State    ${BTN_LOC}    enabled    ${VISIBLE_TO}
    ${before}    Get Url
    Click    role=button[name="Submit & Redirect"]
    Wait For Load State    networkidle    ${NAV_TIMEOUT}
    Run Keyword And Ignore Error    Wait For Elements State    css=.success, css=#result, css=h1    visible    10s

Assert Landed
    [Arguments]    ${url}
    ${current_url}    Get Url
    Should Contain    ${current_url}    ${url}
