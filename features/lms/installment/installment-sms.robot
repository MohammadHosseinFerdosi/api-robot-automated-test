*** Settings ***
Resource            steps/LMS/installment/installment-sms-step.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] BNPL Reminder Follow Up With Penalty Single For 1pay Account
    [Tags]    bnpl
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Complete A Purchase
    And Set Notification Days    day=-7
    And Make User Account Ready To Send Reminder SMS    type=${LMS_Account_Type_1PAY}
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=bnpl.reminder.follow.up.with.penalty.single    claim_type=2
    And The Gateway Is Disabled

[TC-002] BNPL Reminder Follow Up With Penalty Total For 1pay Account
    [Tags]    bnpl
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Notification Days    day=-7
    And Make User Account Ready To Be Validated For Total Debt of Multiple Contracts    type=${LMS_Account_Type_1PAY}
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=bnpl.reminder.follow.up.with.penalty.total    claim_type=2
    And The Gateway Is Disabled

# [TC-003] BNPL Reminder Follow Up Without Penalty Single For Xpay Account
#     [Tags]    bnpl
#     Given Allocate No Fee BNPL Account(xpay)
#     And The Channel Is Set To Linux POS
#     And The Payment Gateway Is Set To BPG
#     And The Gateway RepaymentOption Is Set To 1pay And Xpay
#     And Complete A Purchase
#     And Set Notification Days    day=-6
#     And Make User Account Ready To Send Reminder SMS    type=${LMS_Account_Type_XPAY}
#     When Make Scheduler Enable for Due Date Reminder SMS
#     And Remove Create Notification Lock
#     Then Check The SMS Is Sent To User
#     And Check The SMS Content    sms_type=bnpl.reminder.follow.up.without.penalty.single    claim_type=3,2,1
#     And The Gateway Is Disabled

# [TC-004] BNPL Reminder Follow Up Without Penalty Total For Xpay Account
#     [Tags]    bnpl
#     Given Allocate No Fee BNPL Account(xpay)
#     And The Channel Is Set To Linux POS
#     And The Payment Gateway Is Set To BPG
#     And The Gateway RepaymentOption Is Set To 1pay And Xpay
#     And Set Notification Days    day=-6
#     And Make User Account Ready To Be Validated For Total Debt of Multiple Contracts    type=${LMS_Account_Type_XPAY}
#     When Make Scheduler Enable for Due Date Reminder SMS
#     And Remove Create Notification Lock
#     Then Check The SMS Is Sent To User
#     And Check The SMS Content    sms_type=bnpl.reminder.follow.up.without.penalty.total    claim_type=3,2,1
#     And The Gateway Is Disabled

[TC-005] BNPL Reminder Grace Period Single For 1pay Account
    [Tags]    bnpl
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Complete A Purchase
    And Set Notification Days    day=-2
    And Make User Account Ready To Send Reminder SMS    type=${LMS_Account_Type_1PAY}
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=bnpl.reminder.grace.period.single    claim_type=2
    And The Gateway Is Disabled

[TC-006] BNPL Reminder Grace Period Total For Xpay Account
    [Tags]    bnpl
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay   
    And Set Notification Days    day=-2
    And Make User Account Ready To Be Validated For Total Debt of Multiple Contracts    type=${LMS_Account_Type_1PAY}
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=bnpl.reminder.grace.period.total    claim_type=2
    And The Gateway Is Disabled

[TC-007] BNPL Reminder Grace Period Total Debt For Xpay Account
    [Tags]    bnpl
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Complete A Purchase
    And Set Notification Days    day=-62
    And Make User Account Ready To Send Reminder SMS    type=${LMS_Account_Type_XPAY}
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=bnpl.reminder.grace.period.single.total.debt    claim_type=3,2,1
    And The Gateway Is Disabled

[TC-008] BNPL Reminder Grace Period Total + Total Debt For Xpay Account
    [Tags]    bnpl
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Notification Days    day=-62
    And Make User Account Ready To Be Validated For Total Debt of Multiple Contracts    type=${LMS_Account_Type_XPAY}
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=bnpl.reminder.grace.period.total.total.debt    claim_type=3,2,1
    And The Gateway Is Disabled

[TC-009] BNPL Reminder End Of Grace Period Single For 1pay Account
    [Tags]    bnpl
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Complete A Purchase
    And Set Notification Days    day=-4
    And Make User Account Ready To Send Reminder SMS    type=${LMS_Account_Type_1PAY}
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=bnpl.reminder.end.of.grace.period.single    claim_type=2
    And The Gateway Is Disabled

[TC-010] BNPL Reminder End Of Grace Period Total For Xpay Account
    [Tags]    bnpl
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay   
    And Set Notification Days    day=-4
    And Make User Account Ready To Be Validated For Total Debt of Multiple Contracts    type=${LMS_Account_Type_1PAY}
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=bnpl.reminder.end.of.grace.period.total    claim_type=2
    And The Gateway Is Disabled

[TC-011] BNPL Reminder End Of Grace Period Total Debt For Xpay Account
    [Tags]    bnpl
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Complete A Purchase
    And Set Notification Days    day=-64
    And Make User Account Ready To Send Reminder SMS    type=${LMS_Account_Type_XPAY}
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=bnpl.reminder.end.of.grace.period.single.total.debt    claim_type=3,2,1
    And The Gateway Is Disabled

[TC-012] BNPL Reminder End Of Grace Period Total + Total Debt For Xpay Account
    [Tags]    bnpl
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Notification Days    day=-64
    And Make User Account Ready To Be Validated For Total Debt of Multiple Contracts    type=${LMS_Account_Type_XPAY}
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=bnpl.reminder.end.of.grace.period.total.total.debt    claim_type=3,2,1
    And The Gateway Is Disabled

[TC-013] BNPL Reminder Due Date Single For 1pay Account
    [Tags]    bnpl
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Complete A Purchase
    And Set Notification Days
    And Make User Account Ready To Send Reminder SMS    type=${LMS_Account_Type_1PAY}
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=bnpl.reminder.due.date.single    claim_type=2
    And The Gateway Is Disabled

[TC-014] BNPL Reminder Due Date Total For 1pay Account
    [Tags]    bnpl
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Notification Days
    And Make User Account Ready To Be Validated For Total Debt of Multiple Contracts    type=${LMS_Account_Type_1PAY}
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=bnpl.reminder.due.date.total    claim_type=2
    And The Gateway Is Disabled

[TC-015] BNPL Reminder Due Date Total Debt For Xpay Account
    [Tags]    bnpl
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Complete A Purchase
    And Set Notification Days    -60
    And Make User Account Ready To Send Reminder SMS    type=${LMS_Account_Type_XPAY}
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=bnpl.reminder.due.date.single.total.debt    claim_type=3,2,1
    And The Gateway Is Disabled

[TC-016] BNPL Reminder Due Date Total + Total Debt For Xpay Account
    [Tags]    bnpl
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Set Notification Days    -60
    And Make User Account Ready To Be Validated For Total Debt of Multiple Contracts    type=${LMS_Account_Type_XPAY}
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=bnpl.reminder.due.date.total.total.debt    claim_type=3,2,1
    And The Gateway Is Disabled


[TC-017] C-Credit SMS Reminder 5 Days Before Due Date Single For Tejarat Account
    [Tags]    tejarat    
    Given Allocate No Fee CCredit Account
    And Set Notification Days
    And Make User Account Ready To Send Reminder SMS    type=${LMS_Account_Type_CREDIT}    sms_type=credit.reminder.before5.due.date.single
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=credit.reminder.before5.due.date.single    claim_type=1
[TC-018] C-Credit SMS Reminder 3 Days Before Due Date Single For Tejarat Account
    [Tags]    tejarat    
    Given Allocate No Fee CCredit Account
    And Set Notification Days
    And Make User Account Ready To Send Reminder SMS    type=${LMS_Account_Type_CREDIT}    sms_type=credit.reminder.before3.due.date.single
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=credit.reminder.before3.due.date.single    claim_type=1

[TC-019] C-Credit SMS Reminder Due Date Single For Tejarat Account
    [Tags]    tejarat    
    Given Allocate No Fee CCredit Account
    And Set Notification Days
    And Make User Account Ready To Send Reminder SMS    type=${LMS_Account_Type_CREDIT}
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=credit.reminder.due.date.single    claim_type=2

[TC-020] C-Credit SMS Reminder Due Date Total Debt For Tejarat Account
    [Tags]    tejarat    
    Given Allocate No Fee CCredit Account
    And Set Notification Days
    And Make User Account Ready To Send Reminder SMS    type=${LMS_Account_Type_CREDIT}    sms_type=credit.reminder.due.date.single.total.debt
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=credit.reminder.due.date.credit.single.total.debt.credit    claim_type=3,2

[TC-021] C-Credit SMS Reminder Follow Up Single For Tejarat Account
    [Tags]    tejarat    
    Given Allocate No Fee CCredit Account
    And Set Notification Days
    And Make User Account Ready To Send Reminder SMS    type=${LMS_Account_Type_CREDIT}    sms_type=credit.reminder.follow.up.single
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=credit.reminder.follow.up.single    claim_type=2

[TC-022] C-Credit SMS Reminder Follow Up Single For Tejarat Account
    [Tags]    tejarat    
    Given Allocate No Fee CCredit Account
    And Set Notification Days
    And Make User Account Ready To Send Reminder SMS    type=${LMS_Account_Type_CREDIT}    sms_type=credit.reminder.follow.up.total.debt
    When Make Scheduler Enable for Due Date Reminder SMS
    And Remove Create Notification Lock
    Then Check The SMS Is Sent To User
    And Check The SMS Content    sms_type=credit.reminder.follow.up.total.debt    claim_type=2,3


