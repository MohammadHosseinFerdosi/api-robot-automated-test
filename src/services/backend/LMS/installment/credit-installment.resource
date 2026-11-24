*** Settings ***
Resource        apis/mock-service/mock-api.resource
Variables       services/backend/LMS/installment/models/APIS.yaml


*** Keywords ***
Post Credit API
    [Documentation]    it's used to create    route of apis of found providers
    ...    (mellat, tejarat, saderat) in mock
    [Arguments]    ${route}    ${http_method}=POST    ${statusCode}=200    ${delay}=0    &{payload_dict}

    ${header_list}=    Create List
    &{body}=    Create Dictionary    route=${route}    httpMethod=${http_method}
    ...    statusCode=${statusCode}    delay=${delay}
    ...    payload=&{payload_dict}    headers=${header_list}

    ${response}=    Post Route    &{body}
    Should Be Equal As Strings    ${response['status_code']}    201
    RETURN    ${response['id']}
