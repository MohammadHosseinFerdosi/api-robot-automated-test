*** Settings ***
Library     String
Library     Collections
Library     JSONLibrary
Library     RequestsLibrary
Resource    services/backend/session-service.resource

*** Keywords ***

Post Route
    [Documentation]    Insert route based on `${insert_query}` 
    ...     response Sample :
    ...     {'status_code': 201, 'id': ${id}}
    ...     if route exist first delete it and then insert new one
    ...    insert_query(body) Sample :
    ...    {"route":"/newRoute2","httpMethod":"PUT","statusCode":"200","delay":"0","payload":{"test":true},"headers":[]}
    ...    NOTE: `insert_query` param should be a dictionary.
    [Arguments]    
    ...    &{insert_query}
    ${route}=    Get From Dictionary  ${insert_query}  route
    ${httpMethod}=  Get From Dictionary  ${insert_query}  httpMethod
    
    # Delete route if exist
    ${filter_dict}=   Create Dictionary    route=${route}  httpMethod=${httpMethod}
    ${routes_list}=  Get Routes  ${filter_dict}
    
     ${list_length}=    Get Length    ${routes_list}

    IF  ${list_length} != 0
        ${id}=   Get From Dictionary  ${routes_list}[0]  id
        ${result}=  Delete Route  ${id}
        ${status_code}=  Get From Dictionary  ${result}  status_code
        IF   ${status_code}!=204
            Fail    Delete id: ${id} Failed with: ${status_code}
        END
    END
    

    ${session}    Create A Session    ${MOCKIT_SIDE}
    ${response}    Post On Session    
    ...    ${session}
    ...    ${MOCKIT_URL}
    ...    json=&{insert_query}
    ...    expected_status=any    
    

    
    # Get id
    ${routes_list}=  Get Routes  ${filter_dict}
    ${id}=   Get From Dictionary  ${routes_list}[0]  id
    ${result}    Create Dictionary    status_code=${response.status_code}  id=${id}


    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}

Get Route
    [Documentation]  Get a route based on `${id}` and return route obj as a dict.
    ...    if any routes are  found  `${None}` will be returned.   
    [Arguments]    
    ...    ${id}

    ${session}    Create A Session    ${MOCKIT_ROUTES_SIDE}
    ${response}=    GET On Session
    ...    ${session}
    ...    ${MOCKIT_ROUTES_URL}
    ...    expected_status=any

    ${route} =  Get Value From Json    ${response.json()}    $.routes[?(@.id == '${id}')]

    IF    ${route}
        ${route_dict}=  Get From List  ${route}  0
        RETURN    ${route_dict}    
    ELSE
        RETURN   ${None}
    END
    
    
    [Teardown]    Delete A Session    ${session}


Get Routes
    [Documentation]  Get routes based on `${filter}` as a dict and return json obj.
    ...    if any routes are  found  `[]` will be returned.   
    ...    ${query} sample : $.routes[?(@.route == 'search_route')]
    [Arguments]    
    ...    ${filter}

    ${session}    Create A Session    ${MOCKIT_ROUTES_SIDE}
    ${response}=    GET On Session
    ...    ${session}
    ...    ${MOCKIT_ROUTES_URL}
    ...    expected_status=any
    
    # Get Value From Json    ${response.json()}   $.routes[?(@.route = "/newRoute2" & @.httpMethod = "GET")]
    ${json_path}=    Set Variable   $.routes[?(
    FOR  ${key}  IN    @{filter.keys()}
        ${value}=    Get From Dictionary    ${filter}    ${key}
        # Append to JSONPath
        ${json_path}=    Set Variable    ${json_path}@.${key} = "${value}" & 
    END
    ${json_path}=    Set Variable    ${json_path}[:-1]\)\]


    ${route_list} =  Get Value From Json    ${response.json()}    ${json_path}
        
    RETURN  ${route_list}
    [Teardown]    Delete A Session    ${session}



Put Route
    [Documentation]  Put route based on `${update_query}` and return Status_code = 204.
    ...    if route is not found return Status_code = 204 ! it's bug of mockit
    ...    ${update_query} sample:
    ...    {"id":"3bad159c-08d8-483f-8d49-92d1a505042a","route":"/newRoute","httpMethod":"GET",
    ...    "statusCode":"200","delay":"0","payload":{"test":true,"a":"b"},"headers":[]}
     [Arguments]    
    ...    &{update_query}
    

    ${session}    Create A Session    ${MOCKIT_SIDE}
    ${response}    PUT On Session    
    ...    ${session}
    ...    ${MOCKIT_URL}
    ...    json=&{update_query}
    ...    expected_status=any    
        
    ${result}    Create Dictionary    status_code=${response.status_code}

    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}



Delete Route
    [Documentation]  Delete route based on `${id}` and return Status_code = 204.
    ...    if route is not founded return Status_code = 404.
    [Arguments]    
    ...    ${id}
    
    ${result}    Create Dictionary    status_code=404   # Not Found
    
    ${route_obj}=  Get Route  ${id}

    
    ${route_length}=    Get Length    ${route_obj}
    
    IF  ${route_length} > 0
        ${session}=    Create A Session    ${MOCKIT_SIDE}
        ${response}=    DELETE On Session
        ...    ${session}
        ...    ${MOCKIT_URL}
        ...    json=${route_obj}
        ...    expected_status=any
        Set To Dictionary    ${result}    status_code    ${response.status_code}

    END
    RETURN    ${result}

    [Teardown]    Delete A Session    ${session}
