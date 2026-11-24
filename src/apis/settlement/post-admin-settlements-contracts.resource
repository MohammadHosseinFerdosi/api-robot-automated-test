*** Settings ***
Library         Collections
Library         string
Library         JSONLibrary
Library         RequestsLibrary
Variables       data/CONSTANTS.yaml
Resource        services/backend/session-service.resource


*** Keywords ***
Post Admin Settlements Contracts
    [Documentation]    Creates a settlement contract for a merchant via the admin API.
    ...    Required fields: merchantId, startDate (epoch), endDate (epoch), clauses (list of clause objects), gateway, guild, channel, ownerGroup.
    ...    Optional fields: referralCode (default is empty string).
    ...    
    ...    Example:
    ...    {
    ...        "merchantId": "b8b74993-37fc-47c2-aaca-d325af7d32cd",
    ...        "startDate": 1745131133000,
    ...        "endDate": 1776580733000,
    ...        "clauses": [
    ...            {
    ...                "method": "7",
    ...                "periodParams": [2],
    ...                "settlementDelayDays": 2,
    ...                "periodicType": "0",
    ...                "feeStrategy": "0",
    ...                "feeProperties": {
    ...                    "fixedFeePercent": 10
    ...                },
    ...                "thresholdProperty": {
    ...                    "amount": 0,
    ...                    "count": 0
    ...                }
    ...            }
    ...        ],
    ...        "gateway": 10,
    ...        "guild": "digital",
    ...        "channel": 1,
    ...        "ownerGroup": "merchant-panel",
    ...        "referralCode": ""
    ...    }
    ...    
    ...    Returns a dictionary with status_code and body (parsed JSON response).
    [Arguments]
    ...    ${api_call_side}
    ...    ${merchantId}
    ...    ${startDate}
    ...    ${endDate}
    ...    ${clauses}
    ...    ${gatway}
    ...    ${guild}
    ...    ${channel}
    ...    ${ownerGroup}
    ...    ${user_id}
    ...    ${referralCode}=${EMPTY}


    ${api_path}    Set Variable    /admin/settlements/contracts

    IF    '${api_call_side}' == '${MICROSERVICE_SIDE}'
        ${api_path}    Set Variable    ${MS_SETTLEMENT_PATH}${api_path}
    END


    ${session}    Create A Session    ${api_call_side}
    ${body}    Create Dictionary
    ...    merchantId=${merchantId}
    ...    startDate=${startDate}
    ...    endDate=${endDate}
    ...    clauses=${clauses}
    ...    gateway=${gatway}
    ...    guild=${guild}
    ...    channel=${channel}
    ...    ownerGroup=${ownerGroup}
    ...    referralCode=${referralCode}


    ${headers}    Create Dictionary    
    ...        User-Id=${user_id}
    
    ${response}    POST On Session    ${session}
    ...    ${api_path}
    ...    json=${body}
    ...    headers=${headers}
    ...    expected_status=any


    ${result}    Create Dictionary    status_code=${response.status_code}    body=${response.json()}

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
