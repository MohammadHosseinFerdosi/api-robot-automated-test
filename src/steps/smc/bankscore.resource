*** Settings ***
Resource    apis/smc/POST-smc-bank-api-scores.resource
Resource    services/db/mongo-db-service.resource
Resource    services/backend/value-handler.resource


*** Keywords ***
Enter The information Valid Values And call Api BANK Score
    [Documentation]    Enter Information Valid User For BANK Score
    ${TRACKING_CODE_VALID}    Generate Random String    length=${9}
    ${input_data}    Create Dictionary
    ...    scoreType=${SCORE_TYPE_DP}
    ...    nationalCode=${NATIONAL_CODE_VALID}
    ...    cellNumber=${CELL_NUMBER_VALID}
    ...    serviceType=${SERVICE_TYPE_BNPL}
    ...    trackingCode=${TRACKING_CODE_VALID}
    ${response}    POST SMC Bank API Scores
    ...    ${SCORE_TYPE_DP}
    ...    ${NATIONAL_CODE_VALID}
    ...    ${CELL_NUMBER_VALID}
    ...    ${TRACKING_CODE_VALID}
    ...    ${SERVICE_TYPE_BNPL}
    Set Test Variable    ${TRACKING_CODE_VALID}    ${TRACKING_CODE_VALID}
    Set Test Variable    ${response}
    Set Test Variable    ${Result}    ${response}[body]
    Set Test Variable    ${input_data}

Enter The information NationalCode Invalid And call Api BANK Score
    [Documentation]    Enter Information Valid with NationalCode Invalid User For BANK Score
    ${input_data}    Create Dictionary
    ...    scoreType=${SCORE_TYPE_DP}
    ...    nationalCode=${NATIONAL_CODE_INVALID}
    ...    cellNumber=${CELL_NUMBER_VALID}
    ...    serviceType=${SERVICE_TYPE_BNPL}
    ${TRACKING_CODE_VALID}    Generate Random String    length=${9}
    ${response}    POST SMC Bank API Scores
    ...    ${SCORE_TYPE_DP}
    ...    ${NATIONAL_CODE_INVALID}
    ...    ${CELL_NUMBER_VALID}
    ...    ${TRACKING_CODE_VALID}
    ...    ${SERVICE_TYPE_BNPL}
    Set Test Variable    ${TRACKING_CODE_VALID}
    Set Test Variable    ${response}
    Set Test Variable    ${Result}    ${response}[body]

Enter The Information With NationalCode Null And Call Api BANK Score
    [Documentation]    Enter Information Valid with National Code null User For BANK Score
    ${input_data}    Create Dictionary
    ...    scoreType=${SCORE_TYPE_DP}
    ...    nationalCode=""
    ...    cellNumber=${CELL_NUMBER_VALID}
    ...    serviceType=${SERVICE_TYPE_BNPL}
    ${TRACKING_CODE_VALID}    Generate Random String    length=${9}
    ${response}    POST SMC Bank API Scores
    ...    ${SCORE_TYPE_DP}
    ...    ""
    ...    ${CELL_NUMBER_VALID}
    ...    ${TRACKING_CODE_VALID}
    ...    ${SERVICE_TYPE_BNPL}
    Set Test Variable    ${TRACKING_CODE_VALID}
    Set Test Variable    ${response}
    Set Test Variable    ${Result}    ${response}[body]

Enter The Information With Cellnumber Invalid And Call Api check Api BANK Score
    [Documentation]    Enter Information Valid with Cellnumber Invalid User For BANK Score
    ${input_data}    Create Dictionary
    ...    scoreType=${SCORE_TYPE_DP}
    ...    nationalCode=${NATIONAL_CODE_VALID}
    ...    cellNumber=${CELL_NUMBER_INVALID}
    ...    serviceType=${SERVICE_TYPE_BNPL}
    ${TRACKING_CODE_VALID}    Generate Random String    length=${9}
    ${response}    POST SMC Bank API Scores
    ...    ${SCORE_TYPE_DP}
    ...    ${NATIONAL_CODE_VALID}
    ...    ${CELL_NUMBER_INVALID}
    ...    ${TRACKING_CODE_VALID}
    ...    ${SERVICE_TYPE_BNPL}
    Set Test Variable    ${TRACKING_CODE_VALID}
    Set Test Variable    ${response}
    Set Test Variable    ${Result}    ${response}[body]

Enter The Information With Cellnumber Null And Call Api BANK Score
    [Documentation]    Enter Information Valid with Cellnumber Null User For BANK Score
    ${input_data}    Create Dictionary
    ...    scoreType=${SCORE_TYPE_DP}
    ...    nationalCode=${NATIONAL_CODE_VALID}
    ...    cellNumber=""
    ...    serviceType=${SERVICE_TYPE_BNPL}
    ${TRACKING_CODE_VALID}    Generate Random String    length=${9}
    Set Test Variable    ${TRACKING_CODE_VALID}
    ${response}    POST SMC Bank API Scores
    ...    ${SCORE_TYPE_DP}
    ...    ${NATIONAL_CODE_VALID}
    ...    cellNumber=""
    ...    trackingCode=${TRACKING_CODE_VALID}
    ...    serviceType=${SERVICE_TYPE_BNPL}
    Set Test Variable    ${response}
    Set Test Variable    ${Result}    ${response}[body]

Enter The Information With ServiceType Invalid And Call Api BANK Score
    [Documentation]    Enter Information Valid with Service Type Invalid User For BANK Score
    ${input_data}    Create Dictionary
    ...    scoreType=${SCORE_TYPE_DP}
    ...    nationalCode=${NATIONAL_CODE_VALID}
    ...    cellNumber=${CELL_NUMBER_VALID}
    ...    serviceType=${SERVICE_TYPE_INVALID}
    ${TRACKING_CODE_VALID}    Generate Random String    length=${9}
    ${response}    POST SMC Bank API Scores
    ...    ${SCORE_TYPE_DP}
    ...    ${NATIONAL_CODE_VALID}
    ...    ${CELL_NUMBER_VALID}
    ...    ${TRACKING_CODE_VALID}
    ...    ${SERVICE_TYPE_INVALID}
    Set Test Variable    ${TRACKING_CODE_VALID}
    Set Test Variable    ${response}
    Set Test Variable    ${Result}    ${response}[body]

Enter The Information With ServiceType Null And Call Api BANK Score
    [Documentation]    Enter Information Valid with Service Type Null User For BANK Score
    ${input_data}    Create Dictionary
    ...    scoreType=${SCORE_TYPE_DP}
    ...    nationalCode=${NATIONAL_CODE_VALID}
    ...    cellNumber=${CELL_NUMBER_VALID}
    ...    serviceType=""
    ${TRACKING_CODE_VALID}    Generate Random String    length=${9}
    ${response}    POST SMC Bank API Scores
    ...    ${SCORE_TYPE_DP}
    ...    ${NATIONAL_CODE_VALID}
    ...    ""
    ...    ${CELL_NUMBER_VALID}
    ...    ${TRACKING_CODE_VALID}
    Set Test Variable    ${TRACKING_CODE_VALID}
    Set Test Variable    ${response}
    Set Test Variable    ${Result}    ${response}[body]

Enter The Information With scoreType Invalid And Call Api BANK Score
    [Documentation]    Enter Information Valid with scoreType Invalid User For BANK Score
    ${input_data}    Create Dictionary
    ...    scoreType=${SCORE_TYPE_INVALID}
    ...    nationalCode=${NATIONAL_CODE_VALID}
    ...    cellNumber=${CELL_NUMBER_VALID}
    ...    serviceType=${SERVICE_TYPE_BNPL}
    ${TRACKING_CODE_VALID}    Generate Random String    length=${9}
    Set Test Variable    ${TRACKING_CODE_VALID}
    ${response}    POST SMC Bank API Scores
    ...    ${SCORE_TYPE_INVALID}
    ...    ${NATIONAL_CODE_VALID}
    ...    ${CELL_NUMBER_VALID}
    ...    ${TRACKING_CODE_VALID}
    ...    ${SERVICE_TYPE_BNPL}
    Set Test Variable    ${response}
    Set Test Variable    ${Result}    ${response}[body]

Enter The Information With scoreType Null And Call Api BANK Score
    [Documentation]    Enter Information Valid with scoreType Null User For BANK Score
    ${input_data}    Create Dictionary
    ...    scoreType=""
    ...    nationalCode=${NATIONAL_CODE_VALID}
    ...    cellNumber=${CELL_NUMBER_VALID}
    ...    serviceType=${SERVICE_TYPE_BNPL}
    ${TRACKING_CODE_VALID}    Generate Random String    length=${9}
    Set Test Variable    ${TRACKING_CODE_VALID}
    ${response}    POST SMC Bank API Scores
    ...    ""
    ...    ${NATIONAL_CODE_VALID}
    ...    ${SERVICE_TYPE_BNPL}
    ...    ${CELL_NUMBER_VALID}
    ...    ${TRACKING_CODE_VALID}
    Set Test Variable    ${response}
    Set Test Variable    ${Result}    ${response}[body]

Enter Info Different User With Duplicate TrackingCode And Call Api BANK Score
    [Documentation]    Enter Information New User with Duplicate TrackingCode For BANK Score
    ${input_data}    Create Dictionary
    ...    scoreType=${SCORE_TYPE_DP}
    ...    nationalCode=${NATIONAL_CODE_VALID}
    ...    cellNumber=${CELL_NUMBER_VALID}
    ...    serviceType=${SERVICE_TYPE_BNPL}
    ...    trackingCode=123
    ${generate_response}    POST SMC Bank API Scores
    ...    scoreType=${SCORE_TYPE_DP}
    ...    nationalCode=${NATIONAL_CODE_VALID}
    ...    cellNumber=${CELL_NUMBER_VALID}
    ...    trackingCode=123
    ...    serviceType=${SERVICE_TYPE_BNPL}
    ${generate_body}    Create Dictionary
    ...    scoreType=${SCORE_TYPE_DP}
    ...    nationalCode=${NATIONAL_CODE_VALID_NEWUSER}
    ...    cellNumber=${CELL_NUMBER_VALID}
    ...    serviceType=${SERVICE_TYPE_BNPL}
    ...    trackingCode=123
    ${response}    POST SMC Bank API Scores
    ...    scoreType=${SCORE_TYPE_DP}
    ...    nationalCode=${NATIONAL_CODE_VALID_NEWUSER}
    ...    cellNumber=${CELL_NUMBER_VALID}
    ...    trackingCode=123
    ...    serviceType=${SERVICE_TYPE_BNPL}
    Set Test Variable    ${response}
    Set Test Variable    ${Result}    ${response}[body]

Enter The Information With TrackingCode Invalid And Call Api BANK Score
    [Documentation]    Enter Information Valid with TrackingCode Invalid User For BANK Score
    ${input_data}    Create Dictionary
    ...    scoreType=${SCORE_TYPE_DP}
    ...    nationalCode=${NATIONAL_CODE_VALID}
    ...    cellNumber=${CELL_NUMBER_VALID}
    ...    serviceType=${SERVICE_TYPE_BNPL}
    ...    trackingCode=${TRACKING_CODE_INVALID}
    ${response}    POST SMC Bank API Scores
    ...    ${SCORE_TYPE_DP}
    ...    ${NATIONAL_CODE_VALID}
    ...    ${CELL_NUMBER_VALID}
    ...    ${TRACKING_CODE_INVALID}
    ...    ${SERVICE_TYPE_BNPL}
    Set Test Variable    ${response}
    Set Test Variable    ${Result}    ${response}[body]

Enter The Information With TrackingCode Null And Call Api BANK Score
    [Documentation]    Enter Information Valid with TrackingCode Null User For BANK Score
    ${input_data}    Create Dictionary
    ...    scoreType=${SCORE_TYPE_DP}
    ...    nationalCode=${NATIONAL_CODE_VALID}
    ...    cellNumber=${CELL_NUMBER_VALID}
    ...    serviceType=${SERVICE_TYPE_BNPL}
    ...    trackingCode=
    ${response}    POST SMC Bank API Scores
    ...    ${SCORE_TYPE_DP}
    ...    ${NATIONAL_CODE_VALID}
    ...    ${CELL_NUMBER_VALID}
    ...    trackingCode=
    ...    serviceType=${SERVICE_TYPE_BNPL}
    Set Test Variable    ${response}
    Set Test Variable    ${Result}    ${response}[body]

Enter Data for find information user in DataBase "score_journals" Mango
    [Documentation]    Enter Data for find information user in DataBase Mango
    ${input_data}    Create Dictionary
    ...    ${SMC_MNG_DB_MANE}
    ...    ${SMC_MNG_SCORE_JOURNALS_COLLECTION}
    ...    model.cellNumber=${CELL_NUMBER_VALID}
    ...    trackingCode=${TRACKING_CODE_VALID}
    ${filter_query}    Create Dictionary
    ...    model.cellNumber=${CELL_NUMBER_VALID}
    ...    trackingCode=${TRACKING_CODE_VALID}
    ${response}    Mongo Db Find
    ...    ${SMC_MNG_DB_MANE}
    ...    ${SMC_MNG_SCORE_JOURNALS_COLLECTION}
    ...    ${filter_query}
    Set Test Variable    ${response_db}    ${response}[body]

Enter The information user block And call Api BANK Score
    [Documentation]    Enter Information user blockr For BANK Score
    ${input_data}    Create Dictionary
    ...    scoreType=${SCORE_TYPE_DP}
    ...    nationalCode=${NATIONAL_CODE_BLOCK}
    ...    cellNumber=${CELL_NUMBER_VALID}
    ...    serviceType=${SERVICE_TYPE_BNPL}
    ${TRACKING_CODE_VALID}    Generate Random String    length=${9}
    ${response}    POST SMC Bank API Scores
    ...    ${SCORE_TYPE_DP}
    ...    ${NATIONAL_CODE_BLOCK}
    ...    ${CELL_NUMBER_VALID}
    ...    ${TRACKING_CODE_VALID}
    ...    ${SERVICE_TYPE_BNPL}
    Set Test Variable    ${TRACKING_CODE_VALID}
    Set Test Variable    ${response}
    Set Test Variable    ${Result}    ${response}[body]
    Set Test Variable    ${input_data}

Response To The Status Code Should Be SUCCESS
    [Documentation]    Check Response status code SUCCESS DP Score
    Should Be Equal As Integers
    ...    ${response}[status_code]
    ...    ${SUCCESSFUL_SCORE}[status_code]

Response To The Parameters Should Be SUCCESS
    [Documentation]    Check Response Compelete SUCCESS DP Score
    Should Be Equal As Strings
    ...    ${Result}[result][title]
    ...    ${SUCCESSFUL_SCORE}[title]
    Should Be Equal As Strings
    ...    ${Result}[result][status]
    ...    ${SUCCESSFUL_SCORE}[status]
    Should Be Equal As Strings
    ...    ${Result}[result][message]
    ...    ${SUCCESSFUL_SCORE}[message]
    Should Be Equal As Strings
    ...    ${Result}[result][level]
    ...    ${SUCCESSFUL_SCORE}[level]

Response To The Status Code Should Be "INVALID_PARAMETER"
    [Documentation]    Check Response status code INVALID_PARAMETER DP Score
    Should Be Equal As Integers
    ...    ${response}[status_code]
    ...    ${INVALID_PARAMETERS_SCORE}[status_code]

Response To The Parameters Should Be "INVALID_PARAMETER"
    [Documentation]    Check Response Compelete INVALID_PARAMETER DP Score
    Should Be Equal As Strings
    ...    ${Result}[result][title]
    ...    ${INVALID_PARAMETERS_SCORE}[title]
    Should Be Equal As Strings
    ...    ${Result}[result][status]
    ...    ${INVALID_PARAMETERS_SCORE}[status]
    Should Be Equal As Strings
    ...    ${Result}[result][message]
    ...    ${INVALID_PARAMETERS_SCORE}[message]
    Should Be Equal As Strings
    ...    ${Result}[result][level]
    ...    ${INVALID_PARAMETERS_SCORE}[level]

Response To The Parameters Should Be "INVALID_NATIONALCODE"
    [Documentation]    Check Response Compelete INVALID_PARAMETER DP Score
    Should Be Equal As Strings
    ...    ${Result}[result][title]
    ...    ${INVALID_NATIONAL_CODE}[title]
    Should Be Equal As Strings
    ...    ${Result}[result][status]
    ...    ${INVALID_NATIONAL_CODE}[status]
    Should Be Equal As Strings
    ...    ${Result}[result][message]
    ...    ${INVALID_NATIONAL_CODE}[message]
    Should Be Equal As Strings
    ...    ${Result}[result][level]
    ...    ${INVALID_NATIONAL_CODE}[level]

Response To The Parameters Should Be "DUPLICATE TRACKINGCODE"
    [Documentation]    Check Response Compelete DUPLICATE TRACKINGCODE Bank Score
    Should Be Equal As Strings
    ...    ${Result}[result][title]
    ...    ${INVALID_DUPLICATE_TRACKINGCODE}[title]
    Should Be Equal As Strings
    ...    ${Result}[result][status]
    ...    ${INVALID_DUPLICATE_TRACKINGCODE}[status]
    Should Contain
    ...    ${Result}[result][message]
    ...    ${INVALID_DUPLICATE_TRACKINGCODE}[message]
    Should Be Equal As Strings
    ...    ${Result}[result][level]
    ...    ${INVALID_DUPLICATE_TRACKINGCODE}[level]

Response To The Status Code Should Be "FAILURE"
    [Documentation]    Check Response status code FAILURE DP Score
    Should Be Equal As Integers
    ...    ${response}[status_code]
    ...    ${FAILURE}[status_code]

Response To The Parameters Should Be "FAILURE"
    [Documentation]    Check Response FAILURE Compelete DP Score
    Should Be Equal As Strings
    ...    ${Result}[result][title]
    ...    ${FAILURE}[title]
    Should Be Equal As Strings
    ...    ${Result}[result][status]
    ...    ${FAILURE}[status]
    Should Be Equal As Strings
    ...    ${Result}[result][message]
    ...    ${FAILURE}[message]
    Should Be Equal As Strings
    ...    ${Result}[result][level]
    ...    ${FAILURE}[level]

Check Vulue Params Respone API with DataBase Mango
    [Documentation]    Check    Information Dteails DP Score    in DataBase
    Should Be Equal As Strings
    ...    ${Result}[trackingCode]
    ...    ${response_db[0]['trackingCode']}
    Should Be Equal As Strings
    ...    ${input_data}[nationalCode]
    ...    ${response_db[0]['model']['nationalCode']}
    Should Be Equal As Strings
    ...    ${input_data}[cellNumber]
    ...    ${response_db[0]['model']['cellNumber']}
    Should Be Equal As Strings
    ...    ${input_data}[serviceType]
    ...    ${response_db[0]['model']['serviceType']}

    ${response_db_line_of_credit}    Value Handler    
    ...    ${response_db[0]['scorePayloadResult']['DP_SCORE']['lineOfCredit']}
    ${response_db_one_pay_line_of_credit}    Value Handler    
    ...    ${response_db[0]['scorePayloadResult']['DP_SCORE']['onePayLineOfCredit']}
    ${response_db_x_pay_line_of_credit}    Value Handler    
    ...    ${response_db[0]['scorePayloadResult']['DP_SCORE']['xPayLineOfCredit']}

    Should Be Equal As Strings
    ...    ${Result}[scorePayloadResult][lineOfCredit]
    ...    ${response_db_line_of_credit}
    Should Be Equal As Strings
    ...    ${Result}[scorePayloadResult][onePayLineOfCredit]
    ...    ${response_db_one_pay_line_of_credit}
    Should Be Equal As Strings
    ...    ${Result}[scorePayloadResult][xpayLineOfCredit]
    ...    ${response_db_x_pay_line_of_credit}

Check Vulue Params Respone API with DataBase Mango for user Block
    [Documentation]    Check    Information Dteails DP Score    in DataBase For
    Should Be Equal As Strings
    ...    ${Result}[trackingCode]
    ...    ${response_db[0]['trackingCode']}
    Should Be Equal As Strings
    ...    ${input_data}[nationalCode]
    ...    ${response_db[0]['model']['nationalCode']}
    Should Be Equal As Strings
    ...    ${input_data}[cellNumber]
    ...    ${response_db[0]['model']['cellNumber']}
    Should Be Equal As Strings
    ...    ${input_data}[serviceType]
    ...    ${response_db[0]['model']['serviceType']}

    ${response_db_line_of_credit}    Value Handler    
    ...    ${response_db[0]['scorePayloadResult']['DP_SCORE']['lineOfCredit']}
    ${response_db_one_pay_line_of_credit}    Value Handler    
    ...    ${response_db[0]['scorePayloadResult']['DP_SCORE']['onePayLineOfCredit']}
    ${response_db_x_pay_line_of_credit}    Value Handler    
    ...    ${response_db[0]['scorePayloadResult']['DP_SCORE']['xPayLineOfCredit']}

    Should Be Equal As Strings
    ...    ${Result}[scorePayloadResult][lineOfCredit]
    ...    ${response_db_line_of_credit}

    Should Be Equal As Strings
    ...    ${response_db_line_of_credit}
    ...    -1

    Should Be Equal As Strings
    ...    ${Result}[scorePayloadResult][onePayLineOfCredit]
    ...    ${response_db_one_pay_line_of_credit}

    Should Be Equal As Strings
    ...    ${response_db_one_pay_line_of_credit}
    ...    -1

    Should Be Equal As Strings
    ...    ${Result}[scorePayloadResult][xpayLineOfCredit]
    ...    ${response_db_x_pay_line_of_credit}

    Should Be Equal As Strings
    ...    ${response_db_x_pay_line_of_credit}
    ...    -1
