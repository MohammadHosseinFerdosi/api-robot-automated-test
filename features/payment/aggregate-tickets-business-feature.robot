*** Settings ***
Library         Collections
Library         String
Resource        apis/tgs/post-tickets-business-aggregate.resource
Resource        steps/payment/aggregate-ticket-business-step.resource
Variables       data/payment/purchase/purchase-aggregator.yaml
Test Template    Run Aggregate Ticket And Check Response

*** Test Cases ***     testcase_type   body   status_code    tatus_result    level
Correct Input    
    POSITIVE    ${VALID_AGGREGATE_TICKET}    200    0    INFO 

Null User Id    
    POSITIVE    ${NULL_USER_ID_AGGREGATE_TICKET}    200    0    INFO
User Id Does Not Exit    
    POSITIVE    ${USER_ID_NOT_EXIST_AGGREGATE_TICKET}    200    0    INFO

InCorrect Amount    
    FAILURE    ${INCORRECT_AMOUNT_AGGREGATE_TICKET}    422    1000    BLOCKER

Negative Amount    
    INVALID_PARAMETER    ${NEGATIVE_AMOUNT_AGGREGATE_TICKET}    422    1054    BLOCKER

Null Amount    
    FEATURE_NOT_FOUND    ${NULL_AMOUNT_AGGREGATE_TICKET}    422    1103    WARN

InCorrect Type    
    INVALID_PARAMETER    ${INCORRECT_TYPE_AGGREGATE_TICKET}    422    1054    BLOCKER

InCorrect User Type    
    INVALID_PARAMETER    ${INCORRECT_USER_TYPE_AGGREGATE_TICKET}    422    1054    BLOCKER

InCorrect Basket Id    
    INVALID_PARAMETER    ${INCORRECT_BASKET_ID_AGGREGATE_TICKET}    422    1054    BLOCKER

Null Type    
    FAILURE    ${NULL_TYPE_AGGREGATE_TICKET}    422    1000    BLOCKER

Null UserType     
    POSITIVE    ${NULL_USER_TYPE_AGGREGATE_TICKET}    200    0    INFO   
UserType is 2 and cellnumber is empty    
    INVALID_PARAMETER    ${CHECK_USERTYPE_CELLNUMBER_AGGREGATE_TICKET}    422    1054    BLOCKER

Null Provider Id    
    INVALID_PARAMETER    ${NULL_PROVIDER_ID_AGGREGATE_TICKET}    422    1054    BLOCKER
Duplicate Provider Id     
    TGS_TICKET_EXPIRED    ${DUPLICATE_PROVIDER_ID_AGGREGATE_TICKET}    422    15902    WARN   

InCorrect Cell Number     
    INVALID_PARAMETER    ${INCORRECT_CELLNUMBER_AGGREGATE_TICKET}    422    1054    BLOCKER   

Empty Cell Number     
    INVALID_PARAMETER    ${NULL_CELLNUMBER_AGGREGATE_TICKET}    422    1054    BLOCKER   

Null Redirect URL     
    INVALID_PARAMETER    ${NULL_REDIRECT_URL_AGGREGATE_TICKET}    422    1054    BLOCKER   

Missed Basket Id
    [Tags]    robot:skip
    INVALID_PARAMETER    ${MISSED_BASCKET_ID_AGGREGATE_TICKET}    422    1054    BLOCKER

Invalid Type For Insurance    
    [Tags]    robot:skip
    FAILURE    ${INVALID_TYPE_FOR_INSURANCE_AGGREGATE_TICKET}    422    1000    BLOCKER  

Missed Insurance Type
    [Tags]    robot:skip
    FAILURE    ${MISSED_TYPE_FOR_INSURANCE_AGGREGATE_TICKET}    422    1000    BLOCKER 

Amount 0 for Insurance
    [Tags]    robot:skip
    INVALID_PARAMETER    ${ZERO_AMOUNT_FOR_INSURANCE_AGGREGATE_TICKET}    422    1054    BLOCKER 

Check Amount summation of amounts in split details list
    [Tags]    robot:skip
    INVALID_PARAMETER    ${CHECK_AMOUNT_SUMMATION_AGGREGATE_TICKET}    422    1054    BLOCKER

Null Brand In Policies   
    [Tags]    robot:skip 
    INSURTECH_BRAND_IS_REQUIRED    ${NULL_BRAND_IN_POLICIES_AGGREGATE_TICKET}    422    16250    WARN

Null Model In Policies    
    [Tags]    robot:skip
    INSURTECH_MODEL_IS_REQUIRED    ${NULL_MODEL_IN_POLICIES_AGGREGATE_TICKET}    422    16252    WARN

Null Price In Policies
    [Tags]    robot:skip
    INSURTECH_PRICE_WITH_DISCOUNT_IS_INVALID    ${NULL_PRICE_IN_POLICIES_AGGREGATE_TICKET}    422    16255    WARN

Price Less Than Price With Discount    
    [Tags]    robot:skip
    INSURTECH_PRICE_WITH_DISCOUNT_IS_INVALID    ${PRICE_LESS_THAN_PRICE_WITH_DISCOUNT_AGGREGATE_TICKET}    422    16255     WARN

Same Price And Price With Discount
    [Tags]    robot:skip
    INSURTECH_SELLER_AMOUNT_IS_NOT_MATCHED    ${SAME_PRICE_AND_PRICE_WITH_DISCOUNT_AGGREGATE_TICKET}    422    16256    WARN

Null Category In Policies     
    [Tags]    robot:skip
    INSURTECH_CATEGORY_IS_INVALID    ${NULL_CATEGORY_IN_POLICIES_AGGREGATE_TICKET}    422    16249    WARN

Delete Policies Holder    
    [Tags]    robot:skip
    INSURTECH_POLICY_HOLDER_IS_REQUIRED    ${DELETE_POLICIES_HOLDER_AGGREGATE_TICKET}    422    16235    WARN
Delete Policies       
    [Tags]    robot:skip
    INSURTECH_PRODUCT_INFO_IS_REQUIRED    ${DELETE_POLICIES_AGGREGATE_TICKET}    422    16236    WARN
