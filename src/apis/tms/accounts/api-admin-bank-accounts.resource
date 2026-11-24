*** Settings ***
Resource        services/backend/session-service.resource


*** Keywords ***
Post create bank accounts
    [Documentation]    create bank account
    ...    ${account_Number}
    ...    ${account_TypeId}
    ...    ${bank_Id}
    ...    ${branch_Id}
    ...    ${project_Id}
    ...    ${minimum_Balance}
    ...    ${maximum_Balance}
    ...    ${rahkaranDetailed_AccountCode}
    ...    ${account_CodeId}
    ...    ${iban}
    ...    ${description}
    [Arguments]
    ...    ${api_call_side}
    ...    ${account_Number}
    ...    ${account_TypeId}
    ...    ${bank_Id}
    ...    ${branch_Id}
    ...    ${project_Id}
    ...    ${minimum_Balance}
    ...    ${maximum_Balance}
    ...    ${rahkaranDetailed_AccountCode}
    ...    ${account_CodeId}
    ...    ${iban}
    ...    ${description}
    ${body}    Create Dictionary
    ...    accountNumber=${account_Number}
    ...    accountTypeId=${account_TypeId}
    ...    bankId=${bank_Id}
    ...    branchId=${branch_Id}
    ...    projectId=${project_Id}
    ...    minimumBalance=${minimum_Balance}
    ...    maximumBalance=${maximum_Balance}
    ...    rahkaranDetailedAccountCode=${rahkaranDetailed_AccountCode}
    ...    accountCodeId=${account_CodeId}
    ...    iban=${iban}
    ...    description=${description}

    ${api_path}    Set Variable    /api/admin/bank-accounts

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_BACKOFFICE_TREASURY_PATH}${api_path}
    END

    ${session}    Create A Session    ${api_call_side}


    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    expected_status=any
    IF    '${response.status_code}'=='400'
        ${result}    Create Dictionary    status_code=400    body=[]
    ELSE
        ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    END

    ${result}    Create Dictionary    status_code=${response.status_code}
    RETURN    ${result}
