*** Settings ***
Resource        steps/settlement/contract-initialization.resource
Resource        steps/settlement/contract-step.resource

Test Setup      Initialize Merchant

*** Test Cases ***
Create Contract Successfully
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    When Settlement Admin Create A Contract
    Then Contract Should be Founded    ${DRAFT_STATUS}

Check Duplicate Contract
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    When Settlement Admin Create A Contract twice
    And Add The Business To The Contract Ownerships
    Then Contract Should be Founded    ${DRAFT_STATUS}

Create Contract With Invalid Period Params
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    When Settlement Admin Try To Create A Contract With Invalid Period Params
    Then Contract Should Not be Founded    ${DRAFT_STATUS}

Create Contract With Invalid Gateway
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    When Settlement Admin Try To Create A Contract With Invalid Gateway (Does Not Match With Method)
    Then Contract Response Should Be Equal    ${create_contract_response}    ${INVALID_GATEWAY_WITH_METHOD_CONTENT}


Create Contract With Invalid Channel
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    When Settlement Admin Try To Create A Contract With Invalid Channel
    Then The Contract Should Not be Created

Check Search On Contract That The User has not The Contract OwnerGroup
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships That Does Not Match To The Contract
    When Settlement Admin Create A Contract
    Then Contract Should Not be Founded    ${DRAFT_STATUS}


Change Contract From Draft to Sales Approved
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Admin Try To Create A Contract
    When Sales Try To Change Contract To Sales Approve (sales Approved)    ${SUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should be Changed Successfuly
    And Contract Should be Founded    ${SALES_APPROVED_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Draft to Sales Reject
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Admin Try To Create A Contract
    When Sales Try To Change Contract To Reject (Sales Reject)    ${SUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should be Changed Successfuly
    And Contract Should be Founded    ${REJECT_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Draft to Finance Approve (active)
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Admin Try To Create A Contract
    When Finance Try To Change Contract To Active (Finance Approved)    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${ACTIVATE_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Draft to Finance Reject
    [Tags]    severity:medium
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Admin Try To Create A Contract
    When Finance Try To Change Contract To Reject (Finance Reject)    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${REJECT_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Draft to Suspend
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Admin Try To Create A Contract
    When Settlement Admin Try To Change The Contract To Suspend    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${SUSPEND_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Draft to Terminate
    [Tags]    severity:low
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Admin Try To Create A Contract
    When Settlement Admin Try To change The Contract To Terminate    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${TERMINATE_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Sales Approved to Sales Reject
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Sales Approved A Contract
    When Sales Try To Change Contract To Reject (Sales Reject)    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${REJECT_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Sales Approved to Finance Approve (active)
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Sales Approved A Contract
    When Finance Try To Change Contract To Active (Finance Approved)    ${SUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should be Changed Successfuly
    And Contract Should be Founded    ${ACTIVATE_STATUS}
    And The Contract Should be Synced With Credit

Change Contract From Sales Approved to Finance Reject
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Sales Approved A Contract
    When Finance Try To Change Contract To Reject (Finance Reject)    ${SUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should be Changed Successfuly
    And Contract Should be Founded    ${REJECT_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Sales Approved to Suspend
    [Tags]    severity:medium
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Sales Approved A Contract
    When Settlement Admin Try To Change The Contract To Suspend    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${SUSPEND_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Sales Approved to Terminate
    [Tags]    severity:low
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Sales Approved A Contract
    When Settlement Admin Try To change The Contract To Terminate    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${TERMINATE_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Finance Approved(activate) to Sales Reject
    [Tags]    severity:low
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Finance Approved(activate)
    When Sales Try To Change Contract To Reject (Sales Reject)    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${REJECT_STATUS}
    And The Contract Should be Synced With Credit

Change Contract From Finance Approved(activate) to Sales Approved
    [Tags]    severity:low
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Finance Approved(activate)
    When Sales Try To Change Contract To Sales Approve (sales Approved)    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${SALES_APPROVED_STATUS}
    And The Contract Should be Synced With Credit

Change Contract From Finance Approved(activate) to Finance Reject
    [Tags]    severity:low
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Finance Approved(activate)
    When Finance Try To Change Contract To Reject (Finance Reject)    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${REJECT_STATUS}
    And The Contract Should be Synced With Credit

Change Contract From Finance Approved(activate) to Suspend
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Finance Approved(activate)
    When Settlement Admin Try To Change The Contract To Suspend    ${SUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should be Changed Successfuly
    And Contract Should be Founded    ${SUSPEND_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Finance Approved(activate) to Terminate
    [Tags]    severity:medium
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Finance Approved(activate)
    When Settlement Admin Try To change The Contract To Terminate    ${SUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should be Changed Successfuly
    And Contract Should be Founded    ${TERMINATE_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Suspend to Activate
    [Tags]    severity:low
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Suspend Contract
    When Settlement Admin Try To change The Contract To Active    ${SUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should be Changed Successfuly
    And Contract Should be Founded    ${ACTIVATE_STATUS}
    And The Contract Should be Synced With Credit

Change Contract From Suspend to Sales Approved
    [Tags]    severity:low
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Suspend Contract
    When Sales Try To Change Contract To Sales Approve (sales Approved)    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${REJECT_STATUS}
    And The Contract Should Not Be Exsits With Credit


Change Contract From Suspend to Finance Reject
    [Tags]    severity:low
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Suspend Contract
    When Finance Try To Change Contract To Reject (Finance Reject)    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${REJECT_STATUS}
    And The Contract Should Not Be Exsits With Credit


Change Contract From Suspend to Sales Reject
    [Tags]    severity:low
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Suspend Contract
    When Sales Try To Change Contract To Reject (Sales Reject)    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${REJECT_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Suspend to Terminate
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Suspend Contract
    When Settlement Admin Try To change The Contract To Terminate    ${SUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should be Changed Successfuly
    And Contract Should be Founded    ${TERMINATE_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Terminate to Activate
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Terminate Contract
    When Settlement Admin Try To change The Contract To Active    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${ACTIVATE_STATUS}
    And The Contract Should Not Be Exsits With Credit


Change Contract From Terminate to Sales Approved
    [Tags]    severity:low
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Terminate Contract
    When Sales Try To Change Contract To Sales Approve (sales Approved)    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${SALES_APPROVED_STATUS}
    And The Contract Should Not Be Exsits With Credit


Change Contract From Terminate to Finance Reject
    [Tags]    severity:low
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Terminate Contract
    When Finance Try To Change Contract To Reject (Finance Reject)    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${REJECT_STATUS}
    And The Contract Should Not Be Exsits With Credit


Change Contract From Terminate to Sales Reject
    [Tags]    severity:low
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Terminate Contract
    When Sales Try To Change Contract To Reject (Sales Reject)    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${REJECT_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Terminate to Suspend
    [Tags]    severity:medium
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Terminate Contract
    When Settlement Admin Try To Change The Contract To Suspend    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${SUSPEND_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Reject to Activate
    [Tags]    severity:high
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Reject A Contract
    When Settlement Admin Try To change The Contract To Active    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${ACTIVATE_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Reject to Suspend
    [Tags]    severity:low
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Reject A Contract
    When Settlement Admin Try To Change The Contract To Suspend    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${SUSPEND_STATUS}
    And The Contract Should Not Be Exsits With Credit

Change Contract From Reject to Terminate
    [Tags]    severity:low
    Given Login To Dashboard as Business Admin
    And Add The Business To The Contract Ownerships
    And Settlement Create and Reject A Contract
    When Settlement Admin Try To change The Contract To Terminate    ${UNSUCCESSFUL_CHANGE_CONTRACT_STATUS}
    Then The Contract Status Should Not be Changed Successfuly
    And Contract Should Not be Founded    ${TERMINATE_STATUS}
    And The Contract Should Not Be Exsits With Credit
