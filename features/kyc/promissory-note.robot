*** Settings ***
Resource            steps/kyc/promissory-note-step.resource

Suite Setup         Get Provider Weight
Suite Teardown      Post Default Provider Weight    ${PROVIDERS_WEIGHTS}

*** Test Cases ***
Inquiry Promissory Note When Promissory Note Not Initiated
    When Post Tracking Code Of Promissory Note To Inquiry API
    Then We Should See Promissory Note Not Found Response

Route Promissory Note For Mellat Bank With Etemad Hooshmand Provider
    Given Set Promissory Note Provider    false    ${RECIPIENT_CODE['MELLAT']}    ${ETEMAD_HOOSHMAND_DATA['ETEMAD_HOOSHMAND_ENUM']}
    AND Post Tracking Code Of Promissory Note To Inquiry API
    When Post Tracking Code To Route API    ${RECIPIENT_CODE['MELLAT']}
    Then We should See Route Reponse From Provider    ${ETEMAD_HOOSHMAND_DATA['ETEMAD_HOOSHMAND_ROUTE_RESPONSE']}

Route Promissory Note For Tejarat Bank With Kuknos Provider
    Given Set Promissory Note Provider    false    ${RECIPIENT_CODE['TEJARAT']}    ${KUKNOS_DATA['KUKNOS_ENUM']}
    AND Post Tracking Code Of Promissory Note To Inquiry API
    When Post Tracking Code To Route API    ${RECIPIENT_CODE['TEJARAT']}
    Then We should See Route Reponse From Provider    ${KUKNOS_DATA['KUKNOS_ROUTE_RESPONSE']}

Initiate Promissory Note With Mellat Bank and Etemad Hoshmand Provider
    Given Set Promissory Note Provider    false    ${RECIPIENT_CODE['MELLAT']}    ${ETEMAD_HOOSHMAND_DATA['ETEMAD_HOOSHMAND_ENUM']}
    When Initiate Promissory Note    ${RECIPIENT_CODE['MELLAT']}    ${ETEMAD_HOOSHMAND_DATA['ETEMAD_HOOSHMAND_ROUTE_RESPONSE']}
    Then We should See Initiated Promissory Note With Status 20
    AND We Should See Recepiant Code is 1 and Provider Code Is 4 
    AND Check Database With User Data That We Post

Initiate Promissory Note With Tejarat Bank With Kuknos Provider
    Given Set Promissory Note Provider    false    ${RECIPIENT_CODE['TEJARAT']}    ${KUKNOS_DATA['KUKNOS_ENUM']}
    When Initiate Promissory Note    ${RECIPIENT_CODE['TEJARAT']}    ${KUKNOS_DATA['KUKNOS_ROUTE_RESPONSE']}
    Then We should See Initiated Promissory Note With Status 20
    AND We Should See Recepiant Code is 0 and Provider Code Is 1
    AND Check Database With User Data That We Post

# Initate Payment Promissory Note With Gardeshgari Provider
#    Given Set Promissory Note Provider    false    ${GARDESHGARI_DATA['GARDESHGARI_ENUM']}
#    AND Initiate Promissory Note    ${GARDESHGARI_DATA['GARDESHGARI_ROUTE_RESPONSE']}    ${GARDESHGARI_RECEPIANT_CODE}
#    When Post Tracking Code And User Data To Pay That Initiated Promissory Note For Gardeshgari Provider
#    Then We should See Paied Promissory Note With Status 30

Cancel And Delete Promissory Note That Initiated With Tejarat Bank With Kuknos Provider
    Given Set Promissory Note Provider    false    ${RECIPIENT_CODE['TEJARAT']}    ${KUKNOS_DATA['KUKNOS_ENUM']}
    AND Initiate Promissory Note    ${RECIPIENT_CODE['TEJARAT']}    ${KUKNOS_DATA['KUKNOS_ROUTE_RESPONSE']}
    AND We should See Initiated Promissory Note With Status 20
    When Post Tracking Code To Cancel
    Then We should See Deleted Promissory Note With Status 80

# Cancel And Delete Promissory Note That Paied With Gardeshgari Provider
#    Given Set Promissory Note Provider    false    ${GARDESHGARI_DATA['GARDESHGARI_ENUM']}
#    AND Initiate Promissory Note    ${GARDESHGARI_DATA['GARDESHGARI_ROUTE_RESPONSE']}    ${GARDESHGARI_RECEPIANT_CODE}
#    And Post Tracking Code And User Data To Pay That Initiated Promissory Note For Gardeshgari Provider
#    When Post Tracking Code To Cancel
#    Then We should See Deleted Promissory Note With Status 80

Initiate New Promissory Note When User Has Unfinished Promissory Note With Status 20 With Tejarat Bank With Kuknos Provider
    Given Set Promissory Note Provider    false    ${RECIPIENT_CODE['TEJARAT']}    ${KUKNOS_DATA['KUKNOS_ENUM']}
    AND Initiate Promissory Note    ${RECIPIENT_CODE['TEJARAT']}    ${KUKNOS_DATA['KUKNOS_ROUTE_RESPONSE']}
    AND We should See Initiated Promissory Note With Status 20
    When Initiate New Promissory Note For User That Has Promissory Note With Status 20
    ...    ${RECIPIENT_CODE['TEJARAT']}
    ...    ${KUKNOS_DATA['KUKNOS_ROUTE_RESPONSE']}
    Then We should See Deleted Previous Promissory Note With Status 80
    And We should See Initiated Promissory Note With Status 20

# Initiate New Promissory Note When User Has Unfinished Promissory Note With Status 30 With Gardeshgari Provider
#    Given Set Promissory Note Provider    false    ${GARDESHGARI_DATA['GARDESHGARI_ENUM']}
#    AND Initiate Promissory Note    ${GARDESHGARI_DATA['GARDESHGARI_ROUTE_RESPONSE']}    ${GARDESHGARI_RECEPIANT_CODE}
#    AND Post Tracking Code And User Data To Pay That Initiated Promissory Note For Gardeshgari Provider
#    When Initiate New Promissory Note For User That Has Promissory Note With Status 20
#    ...    ${GARDESHGARI_DATA['GARDESHGARI_ROUTE_RESPONSE']}
#    Then We should See Deleted Previous Promissory Note With Status 80
#    And We should See Initiated Promissory Note With Status 20

# Refund Promissory Note When Paied With Gardeshgari Provider
#    Given Set Promissory Note Provider    false    ${GARDESHGARI_DATA['GARDESHGARI_ENUM']}
#    AND Initiate Promissory Note    ${GARDESHGARI_DATA['GARDESHGARI_ROUTE_RESPONSE']}    ${GARDESHGARI_RECEPIANT_CODE}
#    And Post Tracking Code And User Data To Pay That Initiated Promissory Note For Gardeshgari Provider
#    When Post Tracking Code To Refund User Payment
#    Then We should Success Result
#    AND We Should See Refund Status = 2 With Status 80 In Database

Refund Promissory Note When Initiated With Tejarat Bank With Kuknos Provider
    Given Set Promissory Note Provider    false    ${RECIPIENT_CODE['TEJARAT']}    ${KUKNOS_DATA['KUKNOS_ENUM']}
    AND Initiate Promissory Note    ${RECIPIENT_CODE['TEJARAT']}    ${KUKNOS_DATA['KUKNOS_ROUTE_RESPONSE']}
    AND We should See Initiated Promissory Note With Status 20
    When Post Tracking Code To Refund User Payment
    Then We Should See Promissory Note Invalid Refund Status

Refund Promissory Note When Initiated And Change Status To 30 Manualy With Tejarat Bank With Kuknos Provider
    Given Set Promissory Note Provider    false    ${RECIPIENT_CODE['TEJARAT']}    ${KUKNOS_DATA['KUKNOS_ENUM']}
    AND Initiate Promissory Note    ${RECIPIENT_CODE['TEJARAT']}    ${KUKNOS_DATA['KUKNOS_ROUTE_RESPONSE']}
    AND We should See Initiated Promissory Note With Status 20
    And Change Status Of Promissory Note To 30 Manualy
    When Post Tracking Code To Refund User Payment
    Then We Should See Payment Not Found

Route Promissory Note With Mellat Bank and Etemad Hoshmand Provider
    Given Set Promissory Note Provider    false    ${RECIPIENT_CODE['MELLAT']}    ${ETEMAD_HOOSHMAND_DATA['ETEMAD_HOOSHMAND_ENUM']}
    AND Post Tracking Code Of Promissory Note To Inquiry API
    When Post Tracking Code To Route API    ${RECIPIENT_CODE['MELLAT']}
    Then We should See Route Reponse From Provider    ${ETEMAD_HOOSHMAND_DATA['ETEMAD_HOOSHMAND_ROUTE_RESPONSE']}

# Initate Payment Promissory Note With Kuknos Provider
#    Given Set Promissory Note Provider    false    ${KUKNOS_DATA['KUKNOS_ENUM']}
#    When Post Tracking Code And User Data To Pay That Initiated Promissory Note For Kuknos Provider
#    Then We should See Paied Promissory Note With Status 30

Cancel And Delete Promissory Note That Initiated With Mellat Bank and Etemad Hoshmand Provider
    Given Set Promissory Note Provider    false    ${RECIPIENT_CODE['MELLAT']}    ${ETEMAD_HOOSHMAND_DATA['ETEMAD_HOOSHMAND_ENUM']}
    AND Initiate Promissory Note    ${RECIPIENT_CODE['MELLAT']}    ${ETEMAD_HOOSHMAND_DATA['ETEMAD_HOOSHMAND_ROUTE_RESPONSE']}
    AND We should See Initiated Promissory Note With Status 20
    When Post Tracking Code To Cancel
    Then We should See Deleted Promissory Note With Status 80

# Cancel And Delete Promissory Note That Paied With Kuknos Provider
#    Given Set Promissory Note Provider    false    ${KUKNOS_DATA['KUKNOS_ENUM']}
#    AND Initiate Promissory Note    ${KUKNOS_DATA['KUKNOS_ROUTE_RESPONSE']}    ${GARDESHGARI_RECEPIANT_CODE}
#    AND Post Tracking Code And User Data To Pay That Initiated Promissory Note For Kuknos Provider
#    When Post Tracking Code To Cancel
#    Then We should See Deleted Promissory Note With Status 80

Initiate New Promissory Note When User Has Unfinished Promissory Note With Mellat Bank and Etemad Hoshmand Provider
    Given Set Promissory Note Provider    false    ${RECIPIENT_CODE['MELLAT']}    ${ETEMAD_HOOSHMAND_DATA['ETEMAD_HOOSHMAND_ENUM']}
    AND Initiate Promissory Note    ${RECIPIENT_CODE['MELLAT']}    ${ETEMAD_HOOSHMAND_DATA['ETEMAD_HOOSHMAND_ROUTE_RESPONSE']}
    AND We should See Initiated Promissory Note With Status 20
    When Initiate New Promissory Note For User That Has Promissory Note With Status 20
    ...    ${RECIPIENT_CODE['MELLAT']}    
    ...    ${ETEMAD_HOOSHMAND_DATA['ETEMAD_HOOSHMAND_ROUTE_RESPONSE']}
    Then We should See Deleted Previous Promissory Note With Status 80
    And We should See Initiated Promissory Note With Status 20

# Initiate New Promissory Note When User Has Unfinished Promissory Note With Status 30 With Kuknos Provider
#    Given Set Promissory Note Provider    false    ${KUKNOS_DATA['KUKNOS_ENUM']}
#    AND Initiate Promissory Note    ${KUKNOS_DATA['KUKNOS_ROUTE_RESPONSE']}    ${GARDESHGARI_RECEPIANT_CODE}
#    AND Post Tracking Code And User Data To Pay That Initiated Promissory Note For Kuknos Provider
#    When Initiate New Promissory Note For User That Has Promissory Note With Status 20
#    ...    ${KUKNOS_DATA['KUKNOS_ROUTE_RESPONSE']}
#    Then We should See Deleted Previous Promissory Note With Status 80
#    And We should See Initiated Promissory Note With Status 20

# Refund Promissory Note When Paied With Kuknos Provider
#    Given Set Promissory Note Provider    false    ${KUKNOS_DATA['KUKNOS_ENUM']}
#    AND Initiate Promissory Note    ${KUKNOS_DATA['KUKNOS_ROUTE_RESPONSE']}    ${GARDESHGARI_RECEPIANT_CODE}
#    And Post Tracking Code And User Data To Pay That Initiated Promissory Note For Kuknos Provider
#    When Post Tracking Code To Refund User Payment
#    Then We should Success Result
#    AND We Should See Refund Status = 2 With Status 80 In Database

Refund Promissory Note When Initiated With Mellat Bank and Etemad Hoshmand Provider
    Given Set Promissory Note Provider    false    ${RECIPIENT_CODE['MELLAT']}    ${ETEMAD_HOOSHMAND_DATA['ETEMAD_HOOSHMAND_ENUM']}
    AND Initiate Promissory Note    ${RECIPIENT_CODE['MELLAT']}    ${ETEMAD_HOOSHMAND_DATA['ETEMAD_HOOSHMAND_ROUTE_RESPONSE']}
    AND We should See Initiated Promissory Note With Status 20
    When Post Tracking Code To Refund User Payment
    Then We Should See Promissory Note Invalid Refund Status

Refund Promissory Note When Initiated And Change Status To 30 Manualy With Mellat Bank and Etemad Hoshmand Provider
    Given Set Promissory Note Provider    false    ${RECIPIENT_CODE['MELLAT']}    ${ETEMAD_HOOSHMAND_DATA['ETEMAD_HOOSHMAND_ENUM']}
    AND Initiate Promissory Note    ${RECIPIENT_CODE['MELLAT']}    ${ETEMAD_HOOSHMAND_DATA['ETEMAD_HOOSHMAND_ROUTE_RESPONSE']}
    AND We should See Initiated Promissory Note With Status 20
    AND Change Status Of Promissory Note To 30 Manualy
    When Post Tracking Code To Refund User Payment
    Then We Should See Payment Not Found

Weight Of Provider Should Not More Than 1 With Active Auto Weighting False For Tejarat Bank
    When Set Provider Weight More than 1    false    ${RECIPIENT_CODE['TEJARAT']}
    Then We Should See Exception Invalid Parameters

Weight Of Provider Should Not More Than 1 With Active Auto Weighting False For Mellat Bank
    When Set Provider Weight More than 1    false    ${RECIPIENT_CODE['MELLAT']}
    Then We Should See Exception Invalid Parameters

Weight Of Provider Should Not More Than 1 With Active Auto Weighting False For Gardeshgari Bank
    When Set Provider Weight More than 1    false    ${RECIPIENT_CODE['GARDESHGARI']}
    Then We Should See Exception Invalid Parameters

Weight Of Provider Should Not Less Than 1 With Active Auto Weighting False For Tejarat Bank
    When Set Provider Weight Less than 1    false    ${RECIPIENT_CODE['TEJARAT']}
    Then We Should See Exception Invalid Parameters

Weight Of Provider Should Not Less Than 1 With Active Auto Weighting False For Mellat Bank
    When Set Provider Weight Less than 1    false    ${RECIPIENT_CODE['MELLAT']}
    Then We Should See Exception Invalid Parameters

Weight Of Provider Should Not Less Than 1 With Active Auto Weighting False For Gardeshgari Bank
    When Set Provider Weight Less than 1    false    ${RECIPIENT_CODE['GARDESHGARI']}
    Then We Should See Exception Invalid Parameters
Sum Of Providers Weight Should Not Less Than 1 With Active Auto Weighting False For Tejarat Bank
    When Set Provider Weight That Sum Of Them Is Less Than 1    false    ${RECIPIENT_CODE['TEJARAT']}
    Then We Should See Exception Invalid Parameters

Sum Of Providers Weight Should Not Less Than 1 With Active Auto Weighting False For Mellat Bank
    When Set Provider Weight That Sum Of Them Is Less Than 1    false    ${RECIPIENT_CODE['MELLAT']}
    Then We Should See Exception Invalid Parameters

Sum Of Providers Weight Should Not Less Than 1 With Active Auto Weighting False For Gardeshgari Bank
    When Set Provider Weight That Sum Of Them Is Less Than 1    false    ${RECIPIENT_CODE['GARDESHGARI']}
    Then We Should See Exception Invalid Parameters

Sum Of Providers Weight Should Not More Than 1 With Active Auto Weighting False For Tejarat Bank
    When Set Provider Weight That Sum Of Them Is More Than 1    false        ${RECIPIENT_CODE['TEJARAT']}
    Then We Should See Exception Invalid Parameters

Sum Of Providers Weight Should Not More Than 1 With Active Auto Weighting False For Mellat Bank
    When Set Provider Weight That Sum Of Them Is More Than 1    false        ${RECIPIENT_CODE['MELLAT']}
    Then We Should See Exception Invalid Parameters

Sum Of Providers Weight Should Not More Than 1 With Active Auto Weighting False For Gardeshgari Bank
    When Set Provider Weight That Sum Of Them Is More Than 1    false        ${RECIPIENT_CODE['GARDESHGARI']}
    Then We Should See Exception Invalid Parameters
Sum Of Providers Weight Should Not Be 0 With Active Auto Weighting False For Tejarat Bank
    When Set All Providers Weight To 0    false    ${RECIPIENT_CODE['TEJARAT']}
    Then We Should See Exception Invalid Parameters

Sum Of Providers Weight Should Not Be 0 With Active Auto Weighting False For Mellat Bank
    When Set All Providers Weight To 0    false    ${RECIPIENT_CODE['MELLAT']}
    Then We Should See Exception Invalid Parameters

Sum Of Providers Weight Should Not Be 0 With Active Auto Weighting False For Gardeshgari Bank
    When Set All Providers Weight To 0    false    ${RECIPIENT_CODE['GARDESHGARI']}
    Then We Should See Exception Invalid Parameters

Post Providers Weight With False Active Field For All Providers With Active Auto Weighting False For Tejarat Bank
    When Set All Providers Active Field To false    false    ${RECIPIENT_CODE['TEJARAT']}
    Then We Should See Exception Invalid Parameters

Post Providers Weight With False Active Field For All Providers With Active Auto Weighting False For Mellat Bank
    When Set All Providers Active Field To false    false    ${RECIPIENT_CODE['MELLAT']}
    Then We Should See Exception Invalid Parameters

Post Providers Weight With False Active Field For All Providers With Active Auto Weighting False For Gardeshgari Bank
    When Set All Providers Active Field To false    false    ${RECIPIENT_CODE['GARDESHGARI']}
    Then We Should See Exception Invalid Parameters