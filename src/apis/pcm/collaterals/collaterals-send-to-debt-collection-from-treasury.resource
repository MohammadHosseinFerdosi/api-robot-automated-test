*** Settings ***
Resource        services/backend/session-service.resource
Variables       data/pcm/delivery-reserve-return-post-variables.yaml


*** Keywords ***
Post Collateral Send To Debt Collection From Treasury
    [Documentation]    Send To Debt Collection From Treasury
    ...    ${COLLATERAL_IDS_DEBT}
    ...    ${COLLATERAL_REASEN_ID_DEBT}
    [Arguments]
    ...    ${api_call_side}
    ...    ${COLLATERAL_IDS_DEBT}
    ...    ${COLLATERAL_REASEN_ID_DEBT}
    ${body}    Create Dictionary
    ...    collateralids=${COLLATERAL_IDS_DEBT}
    ...    collateralReasonid=${COLLATERAL_REASEN_ID_DEBT}

    ${api_path}    Set Variable    /api/admin/collaterals/send-to-debt-collection-from-treasury

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_BACKOFFICE_LANDING_PATH}${api_path}
    END

    ${session}    Create A Session    ${api_call_side}

    ${headers}    Create Dictionary
    ...    user-id=test-staff-user
    ...    X-Api-Version=3

    ${response}    POST On Session
    ...    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any
    IF    '${response.status_code}'=='400'
        ${result}    Create Dictionary    status_code=400    body=[]
    ELSE
        ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}
    END

    ${result}    Create Dictionary    status_code=${response.status_code}
    [Teardown]    Delete A Session    ${session}
    RETURN    ${result}
