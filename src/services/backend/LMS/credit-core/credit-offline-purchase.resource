*** Settings ***
Library     library/faker_utils.py    WITH NAME    FakerLibrary
Library     RequestsLibrary
Library     Collections
Library     String
Library     DateTime
Resource    apis/lms/credit-core/post-credit-prepayments-pay-cash-result.resource
Resource    apis/lms/credit-core/post-credit-purchases-init.resource
Resource    apis/lms/credit-core/post-credit-purchases-pay.resource
Resource    apis/lms/credit-core/post-credit-purchases-verify.resource
Resource    apis/lms/credit-core/post-credit-reverses.resource
Resource    apis/lms/credit-core/post-credit-purchases-deliver.resource


*** Keywords ***
Perform A Complete Offline Purchase
    [Documentation]    This service creates offline purchases for channels: 2 Smart POS    and 5 Barcode 6 Linux POS.
    ...    After #Initiating The Offline Purchase, a purchase is started. If it only has a CreditAmount, it can be moved to the Paid state by using #Pay The Credit Amount, making it eligible for verification.
    ...    Otherwise, the purchase remains in the Pending state, requiring the #Pay The Cash step to complete the cash payment. Once the cash payment is made, the purchase reaches the Paid state.
    ...    Finally, by using #Verify The Purchase, the purchase is moved to the Confirmed state.
    ...
    ...    The Input Variables are:
    ...
    ...    1. ${user_id}: User Id of the user we wish do perform the purchase on
    ...
    ...    2. ${credit_id}: Credit Id of the user we wish to perform the purchase on
    ...
    ...
    ...    Returns:
    ...
    ...    1. ${tracking_code}: Tracking Code of the purchase
    ...
    ...    Can Skip (List) Some steps: The available steps are : [`init`, `pay`, `pay_cash_result`, `verify`, and `deliver`]
    [Arguments]
    ...    ${user_id}
    ...    ${credit_id}
    ...    ${amount}=${MIN_AMOUNT}
    ...    ${business_id}=${COMPANY_USER_ID}
    ...    ${channel}=${CHANNEL.LINUX_POS}
    ...    ${terminal_id}=${EMPTY}
    ...    ${skip}=@{EMPTY}

    ${skip_init}    Evaluate    'init' in ${skip}
    ${skip_pay}    Evaluate    'pay' in ${skip}
    ${skip_pay_cash_result}    Evaluate    'pay_cash_result' in ${skip}
    ${skip_verify}    Evaluate    'verify' in ${skip}
    ${skip_deliver}    Evaluate    'deliver' in ${skip}

    IF    '${skip_init}'=='False'
        ${result}    Initiate The Offline Purchase
        ...    user_id=${user_id}
        ...    credit_id=${credit_id}
        ...    amount=${amount}
        ...    business_id=${business_id}
        ...    channel=${channel}
        ...    terminal_id=${terminal_id}

        ${tracking_Code}    Set Variable    ${result['tracking_code']}
        ${cash_amount}    Set Variable    ${result['cash_amount']}
        ${provider_id}    Set Variable    ${result['provider_id']}
    END

    IF    '${skip_pay}'=='False'
        Pay The Credit Amount    tracking_code=${tracking_Code}    provider_id=${provider_id}
    END
    IF    '${skip_pay_cash_result}'=='False'
        IF    ${cash_amount}>0    Pay The Cash    tracking_code=${tracking_code}
    END
    IF    '${skip_verify}'=='False'
        Verify The Purchase
        ...    tracking_code=${tracking_Code}
        ...    provider_id=${provider_id}
        ...    business_id=${business_id}
    END
    IF    '${skip_deliver}'=='False'
        Purchase Deliver
        ...    tracking_code=${tracking_code}
        ...    type=13
        ...    api_call_side=${MICROSERVICE_SIDE}
        ...    user_id=${business_id}
    END

    RETURN    ${tracking_code}

Perform A Reversed Offline Purchase
    [Arguments]
    ...    ${user_id}
    ...    ${credit_id}
    ...    ${amount}=${MIN_AMOUNT}
    ...    ${business_id}=${COMPANY_USER_ID}
    ...    ${channel}=${channel.BARCODE}
    ...    ${terminal_id}=${EMPTY}

    ${result}    Initiate The Offline Purchase
    ...    user_id=${user_id}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    business_id=${business_id}
    ...    channel=${channel}
    ...    terminal_id=${terminal_id}

    ${tracking_Code}    Set Variable    ${result['tracking_code']}
    ${cash_amount}    Set Variable    ${result['cash_amount']}
    ${provider_id}    Set Variable    ${result['provider_id']}

    Pay The Credit Amount    tracking_code=${tracking_Code}    provider_id=${provider_id}
    IF    ${cash_amount}>0    Pay The Cash    tracking_code=${tracking_code}
    Reverse Purchase    tracking_code=${tracking_Code}    provider_id=${provider_id}    business_id=${business_id}

    RETURN    ${tracking_code}

Initiate The Offline Purchase
    [Tags]    robot:private
    [Arguments]
    ...    ${user_id}
    ...    ${credit_id}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${amount}=${MIN_AMOUNT}
    ...    ${business_id}=${LMS_AUTOMATION_BUSINESS_ID}
    ...    ${channel}=${CHANNEL.SMART_POS}
    ...    ${seller_Id}=default
    ...    ${supplier_id}=default
    ...    ${product_code}=default
    ...    ${brand}=default
    ...    ${product_type}=1
    ...    ${count}=1
    ...    ${category_id}=default
    ...    ${sub_category_ids}=default
    ...    ${cheque_eligible}=true
    ...    ${basket_id}=${EMPTY}
    ...    ${provider_id}=${EMPTY}
    ...    ${version}=${MANIFEST_PLATFORM_VERSION}
    ...    ${terminal_id}=${EMPTY}

    IF    '${provider_id}'=='${EMPTY}'
        ${provider_id}    Generate Random String    15    123456789
    END
    IF    '${basket_id}'=='${EMPTY}'
        ${basket_id}    Generate Random String    6    123456789
    END
    ${response_init}    POST Credit Purchases Init
    ...    api_call_side=${api_call_side}
    ...    user_id=${user_id}
    ...    cell_number=${cell_number}
    ...    credit_id=${credit_id}
    ...    amount=${amount}
    ...    provider_id=${provider_id}
    ...    business_id=${business_id}
    ...    channel=${channel}
    ...    seller_Id=${seller_Id}
    ...    supplier_id=${supplier_id}
    ...    product_code=${product_code}
    ...    brand=${brand}
    ...    product_type=${product_type}
    ...    count=${count}
    ...    category_id=${category_id}
    ...    sub_category_ids=${sub_category_ids}
    ...    cheque_eligible=${cheque_eligible}
    ...    basket_id=${basket_id}
    ...    version=${version}
    ...    terminal_id=${terminal_id}

    ${body_init}    Set Variable    ${response_init['body']}
    ${status_code}    Set Variable    ${response_init['status_code']}
    IF    '${status_code}'=='200'
        ${tracking_code}    Set Variable    ${body_init['trackingCode']}
        ${cash_amount}    Set Variable    ${body_init['cashAmount']}

        ${result}    Create Dictionary
        ...    provider_id=${provider_id}
        ...    tracking_code=${tracking_code}
        ...    cash_amount=${cash_amount}
        RETURN    ${result}
    ELSE
        Fail    msg=Could not initiate the purchase, please investigate if that was not intended!
    END

Pay The Credit Amount
    [Tags]    robot:private
    [Arguments]
    ...    ${tracking_code}
    ...    ${provider_id}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ${response_pay}    POST Credit Purchases Pay
    ...    api_call_side=${api_call_side}
    ...    tracking_code=${tracking_code}
    ...    provider_id=${provider_id}
    ${status_code}    Set Variable    ${response_pay['status_code']}
    IF    '${status_code}'!='200'
        Fail    msg=Could not pay the purchase, please investigate if that was not intended!
    END

Pay The Cash
    [Tags]    robot:private
    [Arguments]
    ...    ${tracking_code}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${confirmation_code}=${EMPTY}
    ...    ${rrn}=${EMPTY}
    ...    ${terminal_id}=${EMPTY}
    ...    ${masked_pan}=${EMPTY}
    ...    ${psp_code}=${PSP_CODE.IRKISH}
    ...    ${result_code}=${EMPTY}
    IF    '${confirmation_code}'=='${EMPTY}'
        ${confirmation_code}    Generate Random String    16    123456789
    END
    IF    '${rrn}'=='${EMPTY}'
        ${rrn}    Generate Random String    16    123456789
    END
    IF    '${terminal_id}'=='${EMPTY}'
        ${terminal_id}    Generate Random String    9    123456789
    END
    IF    '${masked_pan}'=='${EMPTY}'
        ${masked_pan}    Generate Random String    16    123456789
    END
    IF    '${result_code}'=='${EMPTY}'
        ${result_code}    Generate Random String    3    123456789
    END
    ${response_prepayment}    POST Credit Prepayment Pay Cash Result
    ...    api_call_side=${api_call_side}
    ...    tracking_code=${tracking_code}
    ...    confirmation_code=${confirmation_code}
    ...    rrn=${rrn}
    ...    terminal_id=${terminal_id}
    ...    masked_pan=${masked_pan}
    ...    psp_code=${PSP_CODE}
    ...    result_code=${result_code}

    ${status_code}    Set Variable    ${response_prepayment['status_code']}
    IF    '${status_code}'!='200'
        Fail    msg=Could not pay the cash of the purchase, please investigate if that was not intended!
    END

Verify The Purchase
    [Tags]    robot:private
    [Arguments]
    ...    ${tracking_code}
    ...    ${provider_id}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}
    ...    ${business_id}=${COMPANY_USER_ID}

    ${response_verify}    POST Credit Purchases Verify
    ...    api_call_side=${api_call_side}
    ...    tracking_code=${tracking_code}
    ...    provider_id=${provider_id}
    ...    user_id=${business_id}

    ${status_code}    Set Variable    ${response_verify['status_code']}
    Set Test Variable    ${purchase_tracking_code}    ${response_verify}[body][trackingCode]

    IF    '${status_code}'!='200'
        Fail    msg=Could not verify the purchase, please investigate if that was not intended!
    END

Reverse Purchase
    [Tags]    robot:private
    [Arguments]
    ...    ${tracking_code}
    ...    ${provider_id}
    ...    ${business_id}=${COMPANY_USER_ID}
    ...    ${api_call_side}=${MICROSERVICE_SIDE}

    ${response_reverse}    POST Credit Purchase Reverse
    ...    api_call_side=${api_call_side}
    ...    tracking_code=${tracking_code}
    ...    provider_id=${provider_id}
    ...    user_id=${business_id}

    ${status_code}    Set Variable    ${response_reverse['status_code']}
    IF    '${status_code}'!='200'
        Fail    msg=Purchase Reverse Failed. Please Investigate if that was not intended.
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

    Should Be Equal As Strings
    ...    ${status_code}
    ...    200
    ...    msg=Delivering the purchase has failed, please investigate if that was not intended!
