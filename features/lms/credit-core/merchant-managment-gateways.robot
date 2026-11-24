*** Settings ***
Resource            steps/LMS/credit-core/account-merchant-management.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] Call Account Info For 1Pay, XPay BNPL With Channel UPG , RepaymentOption 1Pay, XPay
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain Configs OTP
    And The Gateway Is Disabled

[TC-002] Call Account Info for 1Pay BNPL With Channel UPG, RepaymentOption 1Pay
    Given The User Has 1pay Account
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    When Get Merchant Account Info
    Then The Response Should Contain RepaymentOptions One-pay
    And The Gateway Is Disabled

[TC-003] Call Account Info For XPay BNPL With Channel UPG, RepaymentOption XPay
    Given The User Has 4pay Account
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    When Get Merchant Account Info
    Then The Response Should Contain RepaymentOptions X-Pay
    And The Gateway Is Disabled

[TC-004] Call Account Info For XPay BNPL With Channel UPG, RepaymentOption 1Pay
    Given The User Has 4pay Account
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    When Get Merchant Account Info
    Then The Response Should Contain RepaymentOptions One-pay
    And The Gateway Is Disabled

[TC-005] Check Gateway Config For BussinessId
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain BusinessId
    And The Gateway Is Disabled

[TC-006] Check Gateway Config For Channel
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain Gateways And UPG Channel
    And The Gateway Is Disabled

[TC-007] Check Gateway Config For Otp
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain Configs OTP
    And The Gateway Is Disabled

[TC-008] Check Gateway Config For Show Balance
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain Configs ShowBalance
    And The Gateway Is Disabled

[TC-009] Check Gateway Config For Disabled Gateway
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Gateway Is Disabled
    When Get Merchant Account Info
    Then The Response Should Contain The Gateway doesn't Exist

[TC-010] Check The ShowBalance And otpThreshold On DB For One-pay
    Given The User Has 1pay Account
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    When Get Merchant Account Info
    Then Check showBalance And otpThreshold On DB
    And The Gateway Is Disabled

[TC-011] Check The ShowBalance And otpThreshold On DB For X-pay
    Given The User Has 4pay Account
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    When Get Merchant Account Info
    Then Check showBalance And otpThreshold On DB
    And The Gateway Is Disabled

[TC-012] Check Gateway Config on DB For UPG
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To UPG
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then Check On DB False ShowBalance
    And The Gateway Is Disabled

[TC-013] Call Account Info For 1Pay, XPay BNPL With Channel API , RepaymentOption 1Pay, XPay
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To API
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain Configs OTP
    And The Gateway Is Disabled

[TC-014] Call Account Info for 1Pay BNPL With Channel API, RepaymentOption 1Pay
    Given The User Has 1pay Account
    And The Channel Set To API
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    When Get Merchant Account Info
    Then The Response Should Contain RepaymentOptions One-pay
    And The Gateway Is Disabled

[TC-015] Call Account Info For XPay BNPL With Channel API, RepaymentOption XPay
    Given The User Has 4pay Account
    And The Channel Set To API
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    When Get Merchant Account Info
    Then The Response Should Contain RepaymentOptions X-Pay
    And The Gateway Is Disabled

[TC-016] Call Account Info For XPay BNPL With Channel API, RepaymentOption 1Pay
    Given The User Has 4pay Account
    And The Channel Set To API
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    When Get Merchant Account Info
    Then The Response Should Contain RepaymentOptions One-pay
    And The Gateway Is Disabled

[TC-017] Check BussinessId In Gateway Config For Channel API
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To API
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain BusinessId
    And The Gateway Is Disabled

[TC-018] Check Channel In Gateway Config For Channel API
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To API
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain Gateways And Api Channel
    And The Gateway Is Disabled

[TC-019] Check The Otp In Gateway Config For Channel API
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To API
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain Configs OTP
    And The Gateway Is Disabled

[TC-020] Check Show Balance In Gateway Config For Channel API
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To API
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain Configs ShowBalance
    And The Gateway Is Disabled

[TC-021] Check Disabled Gateway Gateway Config For Channel API
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To API
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Gateway Is Disabled
    When Get Merchant Account Info
    Then The Response Should Contain The Gateway doesn't Exist

[TC-022] Check The ShowBalance And otpThreshold On DB For One-pay For Channel API
    Given The User Has 1pay Account
    And The Channel Set To API
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    When Get Merchant Account Info
    Then Check showBalance And otpThreshold On DB
    And The Gateway Is Disabled

[TC-023] Check The ShowBalance And otpThreshold On DB For X-pay For Channel API
    Given The User Has 4pay Account
    And The Channel Set To API
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    When Get Merchant Account Info
    Then Check showBalance And otpThreshold On DB
    And The Gateway Is Disabled

[TC-024] Check Gateway Config on DB For API
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To API
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then Check On DB False ShowBalance
    And The Gateway Is Disabled

[TC-025] Call Account Info For 1Pay, XPay BNPL With Channel SMART_POS , RepaymentOption 1Pay, XPay
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Smart POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain Configs OTP
    And The Gateway Is Disabled

[TC-026] Call Account Info for 1Pay BNPL With Channel SMART_POS, RepaymentOption 1Pay
    Given The User Has 1pay Account
    And The Channel Set To Smart POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    When Get Merchant Account Info
    Then The Response Should Contain RepaymentOptions One-pay
    And The Gateway Is Disabled

[TC-027] Call Account Info For XPay BNPL With Channel SMART_POS, RepaymentOption XPay
    Given The User Has 4pay Account
    And The Channel Set To Smart POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    When Get Merchant Account Info
    Then The Response Should Contain RepaymentOptions X-Pay
    And The Gateway Is Disabled

[TC-028] Call Account Info For XPay BNPL With Channel SMART_POS, RepaymentOption 1Pay
    Given The User Has 4pay Account
    And The Channel Set To Smart POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    When Get Merchant Account Info
    Then The Response Should Contain RepaymentOptions One-pay
    And The Gateway Is Disabled

[TC-029] Check BussinessId In Gateway Config For Channel SMART_POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Smart POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain BusinessId
    And The Gateway Is Disabled

[TC-030] Check Channel In Gateway Config For Channel SMART_POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Smart POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain Gateways And SMART_POS Channel
    And The Gateway Is Disabled

[TC-031] Check The Otp In Gateway Config For Channel SMART_POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Smart POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain Configs OTP
    And The Gateway Is Disabled

[TC-032] Check The Gateway Disable On Credit Merchant Management DB For Channel SMART_POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Smart POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Get Merchant Account Info
    Then Check The Gateway Disable On DB Credit Merchant Management
   

[TC-033] Check Disabled Gateway Gateway Config For Channel SMART_POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Smart POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Gateway Is Disabled
    When Get Merchant Account Info
    Then The Response Should Contain The Gateway doesn't Exist

[TC-034] Check The ShowBalance And otpThreshold On DB For One-pay For Channel SMART_POS
    Given The User Has 1pay Account
    And The Channel Set To Smart POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    When Get Merchant Account Info
    Then Check showBalance And otpThreshold On DB
    And The Gateway Is Disabled

[TC-035] Check The ShowBalance And otpThreshold On DB For X-pay For Channel SMART_POS
    Given The User Has 4pay Account
    And The Channel Set To Smart POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    When Get Merchant Account Info
    Then Check showBalance And otpThreshold On DB
    And The Gateway Is Disabled

[TC-036] Check Gateway Config on DB For SMART_POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Smart POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then Check On DB True ShowBalance
    And The Gateway Is Disabled

[TC-037] Call Account Info For 1Pay, XPay BNPL With Channel LINUX_POS , RepaymentOption 1Pay, XPay
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Linux POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain Configs OTP
    And The Gateway Is Disabled

[TC-038] Call Account Info for 1Pay BNPL With Channel LINUX_POS, RepaymentOption 1Pay
    Given The User Has 1pay Account
    And The Channel Set To Linux POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    When Get Merchant Account Info
    Then The Response Should Contain RepaymentOptions One-pay
    And The Gateway Is Disabled

[TC-039] Call Account Info For XPay BNPL With Channel LINUX_POS, RepaymentOption XPay
    Given The User Has 4pay Account
    And The Channel Set To Linux POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    When Get Merchant Account Info
    Then The Response Should Contain RepaymentOptions X-Pay
    And The Gateway Is Disabled

[TC-040] Call Account Info For XPay BNPL With Channel LINUX_POS, RepaymentOption 1Pay
    Given The User Has 4pay Account
    And The Channel Set To Linux POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    When Get Merchant Account Info
    Then The Response Should Contain RepaymentOptions One-pay
    And The Gateway Is Disabled

[TC-041] Check BussinessId In Gateway Config For Channel LINUX_POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Linux POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain BusinessId
    And The Gateway Is Disabled

[TC-042] Check Channel In Gateway Config For Channel LINUX_POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Linux POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain Gateways And Linux POS Channel
    And The Gateway Is Disabled

[TC-043] Check The Otp In Gateway Config For Channel LINUX_POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Linux POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then The Response Should Contain Configs OTP
    And The Gateway Is Disabled

[TC-044] Check Disabled Gateway Gateway Config For Channel LINUX_POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Linux POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Gateway Is Disabled
    When Get Merchant Account Info
    Then The Response Should Contain The Gateway doesn't Exist

[TC-045] Check The ShowBalance And otpThreshold On DB For One-pay For Channel LINUX_POS
    Given The User Has 1pay Account
    And The Channel Set To Linux POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay
    When Get Merchant Account Info
    Then Check showBalance And otpThreshold On DB
    And The Gateway Is Disabled

[TC-046] Check The ShowBalance And otpThreshold On DB For X-pay For Channel LINUX_POS
    Given The User Has 4pay Account
    And The Channel Set To Linux POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To Xpay
    When Get Merchant Account Info
    Then Check showBalance And otpThreshold On DB
    And The Gateway Is Disabled

[TC-047] Check Gateway Config on DB For LINUX_POS
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Linux POS
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then Check On DB True ShowBalance
    And The Gateway Is Disabled

[TC-048] Check Gateway Config on DB For QR
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To QR
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then Check On DB True ShowBalance
    And The Gateway Is Disabled

[TC-049] Check Gateway Config on DB For Barcode
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Barcode
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then Check On DB True ShowBalance
    And The Gateway Is Disabled

[TC-050] Check Gateway Config on DB For Escrow
    Given The User Has 1pay And 4pay Accounts
    And The Channel Set To Escrow
    And The Type Set To BNPL
    And The Gateway Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Get Merchant Account Info
    Then Check On DB False ShowBalance
    And The Gateway Is Disabled






    




    