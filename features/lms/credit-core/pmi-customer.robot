*** Settings ***
Resource            steps/LMS/credit-core/payment-methods-customer-steps.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount And Credit Gateway Disable


*** Test Cases ***
[TC-001][Business Side] User Has [1PAY] Account But Business Has No Active Gateway On Channel UPG
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Status Code Must Be 422

[TC-002][Business Side] User Has [1PAY] Account But Business Has No Active Gateway On Channel QR
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Status Code Must Be 422

[TC-003][Business Side] User Has [1PAY] Account But Business Has No Active Gateway On Channel SMART_POS
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Status Code Must Be 422

[TC-004][Business Side] User Has [1PAY] Account But Business Has No Active Gateway On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set channel BARCODE
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Status Code Must Be 422

[TC-005][Business Side] User Has [1PAY] Account But Business Has No Active Gateway On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set channel LINUX_POS
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Status Code Must Be 422

[TC-006][Business Side] User Has [1PAY] Account And Business Has All Possible Active Gateway On Channel UPG
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Have The Length    expected_length=4

[TC-007][Business Side] User Has [1PAY] Account And Business Has All Possible Active Gateway On Channel QR
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Have The Length    expected_length=4

[TC-008][Business Side] User Has [1PAY] Account And Business Has All Possible Active Gateway On Channel SMART_POS
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Have The Length    expected_length=4

[TC-009][Business Side] User Has [1PAY] Account And Business Has All Possible Active Gateway On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Have The Length    expected_length=4

[TC-010][Business Side] User Has [1PAY] Account And Business Has All Possible Active Gateway On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Have The Length    expected_length=4

[TC-011][Business Side] User Has [1PAY] Account And Business Does Not Have Active [BPG] Gateway On Channel UPG
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Credit Gateway Disable
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Include A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=3

[TC-012][Business Side] User Has [1PAY] Account And Business Does Not Have Active [CPG] Gateway On Channel QR
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Activate All Gateways
    And Credit Gateway Disable
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Include A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=3

[TC-013][Business Side] User Has [1PAY] Account And Business Does Not Have Active [CAPG] Gateway On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CAPG
    And Activate All Gateways
    And Credit Gateway Disable
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Include A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    And Customer Payment Methods Should Have The Length    expected_length=3

[TC-014][Business Side] User Has [1PAY] Account And Business Does Not Have Active [ISPG] Gateway On Channel SMART_POS
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Activate All Gateways
    And Credit Gateway Disable
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Include A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=3

[TC-015][Business Side] User Has [INSTALLMENT_SALE] Account And Business Does Not Have Active [ISPG] Gateway On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Activate All Gateways
    And Credit Gateway Disable
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Include A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=3

[TC-016][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-017][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-018][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-019][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-020][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-021][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-022][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-023][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-024][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-025][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-026][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-027][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-028][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-029][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-030][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-031][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-032][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-033][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-034][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-035][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-036][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-037][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-038][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-039][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-040][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY, XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-041][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-042][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-043][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-044][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-045][Customer Side-CAPG] User Has [No] Account And Business Has An Active [CAPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CAPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CAPG}
    ...    expected_balance=None
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-046][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-047][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-048][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-049][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-050][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-051][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-052][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-053][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-054][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-055][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-056][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-057][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-058][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-059][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-060][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-061][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-062][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-063][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-064][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-065][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-066][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-067][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-068][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-069][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-070][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-071][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-072][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-073][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-074][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-075][Customer Side-CPG] User Has [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=10002
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-076][Customer Side-CPG] User Has EXPIRED [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-077][Customer Side-CPG] User Has EXPIRED [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-078][Customer Side-CPG] User Has EXPIRED [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-079][Customer Side-CPG] User Has EXPIRED [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-080][Customer Side-CPG] User Has EXPIRED [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-081][Customer Side-CPG] User Has EXPIRED [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-082][Customer Side-CPG] User Has EXPIRED [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-083][Customer Side-CPG] User Has EXPIRED [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-084][Customer Side-CPG] User Has EXPIRED [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-085][Customer Side-CPG] User Has EXPIRED [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-086][Customer Side-CPG] User Has EXPIRED [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-087][Customer Side-CPG] User Has EXPIRED [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-088][Customer Side-CPG] User Has EXPIRED [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-089][Customer Side-CPG] User Has EXPIRED [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-090][Customer Side-CPG] User Has EXPIRED [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-091][Customer Side-CPG] User Has An Empty [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-092][Customer Side-CPG] User Has An Empty [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] And On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-093][Customer Side-CPG] User Has An Empty [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] And On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-094][Customer Side-CPG] User Has An Empty [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-095][Customer Side-CPG] User Has An Empty [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] And On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-096][Customer Side-CPG] User Has An Empty [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] And On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-097][Customer Side-CPG] User Has An Empty [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-098][Customer Side-CPG] User Has An Empty [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] And On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-099][Customer Side-CPG] User Has An Empty [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] And On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-100][Customer Side-CPG] User Has An Empty [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-101][Customer Side-CPG] User Has An Empty [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] And On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-102][Customer Side-CPG] User Has An Empty [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] And On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-103][Customer Side-CPG] User Has An Empty [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-104][Customer Side-CPG] User Has An Empty [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] And On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-105][Customer Side-CPG] User Has An Empty [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] And On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-106][Customer Side-CPG] User Has Blocked [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-107][Customer Side-CPG] User Has Blocked [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-108][Customer Side-CPG] User Has Blocked [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-109][Customer Side-CPG] User Has Blocked [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-110][Customer Side-CPG] User Has Blocked [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-111][Customer Side-CPG] User Has Blocked [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-112][Customer Side-CPG] User Has Blocked [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-113][Customer Side-CPG] User Has Blocked [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-114][Customer Side-CPG] User Has Blocked [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-115][Customer Side-CPG] User Has Blocked [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-116][Customer Side-CPG] User Has Blocked [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-117][Customer Side-CPG] User Has Blocked [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-118][Customer Side-CPG] User Has Blocked [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-119][Customer Side-CPG] User Has Blocked [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-120][Customer Side-CPG] User Has Blocked [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-121][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-122][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-123][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-124][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-125][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-126][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-127][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-128][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-129][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-130][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-131][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-132][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-133][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-134][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-135][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-136][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-137][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-138][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-139][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-140][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-141][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-142][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-143][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-144][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-145][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-146][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-147][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-148][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-149][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-150][Customer Side-ISPG] User Has [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=10003
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-151][Customer Side-ISPG] User Has EXPIRED [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-152][Customer Side-ISPG] User Has EXPIRED [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-153][Customer Side-ISPG] User Has EXPIRED [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-154][Customer Side-ISPG] User Has EXPIRED [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-155][Customer Side-ISPG] User Has EXPIRED [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-156][Customer Side-ISPG] User Has EXPIRED [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-157][Customer Side-ISPG] User Has EXPIRED [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-158][Customer Side-ISPG] User Has EXPIRED [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-159][Customer Side-ISPG] User Has EXPIRED [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-160][Customer Side-ISPG] User Has EXPIRED [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-161][Customer Side-ISPG] User Has EXPIRED [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-162][Customer Side-ISPG] User Has EXPIRED [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-163][Customer Side-ISPG] User Has EXPIRED [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-164][Customer Side-ISPG] User Has EXPIRED [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-165][Customer Side-ISPG] User Has EXPIRED [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-166][Customer Side-ISPG] User Has An Empty [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-167][Customer Side-ISPG] User Has An Empty [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] And On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-168][Customer Side-ISPG] User Has An Empty [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] And On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-169][Customer Side-ISPG] User Has An Empty [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-170][Customer Side-ISPG] User Has An Empty [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] And On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-171][Customer Side-ISPG] User Has An Empty [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] And On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-172][Customer Side-ISPG] User Has An Empty [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-173][Customer Side-ISPG] User Has An Empty [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] And On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-174][Customer Side-ISPG] User Has An Empty [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] And On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-175][Customer Side-ISPG] User Has An Empty [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-176][Customer Side-ISPG] User Has An Empty [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] And On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-177][Customer Side-ISPG] User Has An Empty [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] And On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-178][Customer Side-ISPG] User Has An Empty [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-179][Customer Side-ISPG] User Has An Empty [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] And On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-180][Customer Side-ISPG] User Has An Empty [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] And On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-181][Customer Side-ISPG] User Has Blocked [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-182][Customer Side-ISPG] User Has Blocked [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-183][Customer Side-ISPG] User Has Blocked [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-184][Customer Side-ISPG] User Has Blocked [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-185][Customer Side-ISPG] User Has Blocked [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-186][Customer Side-ISPG] User Has Blocked [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-187][Customer Side-ISPG] User Has Blocked [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-188][Customer Side-ISPG] User Has Blocked [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-189][Customer Side-ISPG] User Has Blocked [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-190][Customer Side-ISPG] User Has Blocked [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-191][Customer Side-ISPG] User Has Blocked [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-192][Customer Side-ISPG] User Has Blocked [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-193][Customer Side-ISPG] User Has Blocked [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY, XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-194][Customer Side-ISPG] User Has Blocked [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [1PAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-195][Customer Side-ISPG] User Has Blocked [INSTALLMENT_SALE] Account And Business Has An Active [ISPG] Gateway With Repayment Option [XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_ISPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-196][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-197][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-198][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-199][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-200][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-201][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-202][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-203][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-204][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-205][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-206][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-207][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-208][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-209][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-210][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-211][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-212][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-213][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-214][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-215][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-216][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-217][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-218][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-219][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-220][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-221][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-222][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-223][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-224][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-225][Customer Side-Just-XPAY] User Has [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-226][Customer Side-Just-XPAY] User Has EXPIRED [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-227][Customer Side-Just-XPAY] User Has EXPIRED [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-228][Customer Side-Just-XPAY] User Has EXPIRED [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-229][Customer Side-Just-XPAY] User Has EXPIRED [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-230][Customer Side-Just-XPAY] User Has EXPIRED [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-231][Customer Side-Just-XPAY] User Has EXPIRED [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-232][Customer Side-Just-XPAY] User Has EXPIRED [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-233][Customer Side-Just-XPAY] User Has EXPIRED [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-234][Customer Side-Just-XPAY] User Has EXPIRED [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-235][Customer Side-Just-XPAY] User Has EXPIRED [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-236][Customer Side-Just-XPAY] User Has EXPIRED [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-237][Customer Side-Just-XPAY] User Has EXPIRED [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-238][Customer Side-Just-XPAY] User Has EXPIRED [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-239][Customer Side-Just-XPAY] User Has EXPIRED [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-240][Customer Side-Just-XPAY] User Has EXPIRED [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-241][Customer Side-Just-XPAY] User Has An Empty [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    amount=60000
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-242][Customer Side-Just-XPAY] User Has An Empty [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    amount=60000
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-243][Customer Side-Just-XPAY] User Has An Empty [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    amount=60000
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-244][Customer Side-Just-XPAY] User Has An Empty [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    amount=60000
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-245][Customer Side-Just-XPAY] User Has An Empty [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    amount=60000
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-246][Customer Side-Just-XPAY] User Has An Empty [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    amount=60000
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-247][Customer Side-Just-XPAY] User Has An Empty [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    amount=60000
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-248][Customer Side-Just-XPAY] User Has An Empty [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    amount=60000
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-249][Customer Side-Just-XPAY] User Has An Empty [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    amount=60000
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-250][Customer Side-Just-XPAY] User Has An Empty [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    amount=60000
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-251][Customer Side-Just-XPAY] User Has An Empty [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    amount=60000
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-252][Customer Side-Just-XPAY] User Has An Empty [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    amount=60000
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-253][Customer Side-Just-XPAY] User Has An Empty [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    amount=60000
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-254][Customer Side-Just-XPAY] User Has An Empty [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    amount=60000
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-255][Customer Side-Just-XPAY] User Has An Empty [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    amount=60000
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-256][Customer Side-Just-XPAY] User Has Blocked [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-257][Customer Side-Just-XPAY] User Has Blocked [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-258][Customer Side-Just-XPAY] User Has Blocked [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-259][Customer Side-Just-XPAY] User Has Blocked [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-260][Customer Side-Just-XPAY] User Has Blocked [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-261][Customer Side-Just-XPAY] User Has Blocked [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-262][Customer Side-Just-XPAY] User Has Blocked [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-263][Customer Side-Just-XPAY] User Has Blocked [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-264][Customer Side-Just-XPAY] User Has Blocked [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-265][Customer Side-Just-XPAY] User Has Blocked [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-266][Customer Side-Just-XPAY] User Has Blocked [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-267][Customer Side-Just-XPAY] User Has Blocked [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-268][Customer Side-Just-XPAY] User Has Blocked [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-269][Customer Side-Just-XPAY] User Has Blocked [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-270][Customer Side-Just-XPAY] User Has Blocked [XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-271][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-272][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-273][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-274][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-275][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-276][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-277][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-278][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-279][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-280][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-281][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-282][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-283][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-284][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-285][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-286][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-287][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-288][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-289][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-290][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-291][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-292][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-293][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-294][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-295][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-296][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-297][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-298][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-299][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-300][Customer Side-Just-1PAY] User Has [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-301][Customer Side-Just-1PAY] User Has EXPIRED [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-302][Customer Side-Just-1PAY] User Has EXPIRED [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-303][Customer Side-Just-1PAY] User Has EXPIRED [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-304][Customer Side-Just-1PAY] User Has EXPIRED [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-305][Customer Side-Just-1PAY] User Has EXPIRED [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-306][Customer Side-Just-1PAY] User Has EXPIRED [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-307][Customer Side-Just-1PAY] User Has EXPIRED [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-308][Customer Side-Just-1PAY] User Has EXPIRED [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-309][Customer Side-Just-1PAY] User Has EXPIRED [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-310][Customer Side-Just-1PAY] User Has EXPIRED [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-311][Customer Side-Just-1PAY] User Has EXPIRED [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-312][Customer Side-Just-1PAY] User Has EXPIRED [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-313][Customer Side-Just-1PAY] User Has EXPIRED [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-314][Customer Side-Just-1PAY] User Has EXPIRED [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-315][Customer Side-Just-1PAY] User Has EXPIRED [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase
    And Empty Balance
    And Expire Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-316][Customer Side-Just-1PAY] User Has An Empty [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] And On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-317][Customer Side-Just-1PAY] User Has An Empty [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] And On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False

    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-318][Customer Side-Just-1PAY] User Has An Empty [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] And On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-319][Customer Side-Just-1PAY] User Has An Empty [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] And On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-320][Customer Side-Just-1PAY] User Has An Empty [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] And On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-321][Customer Side-Just-1PAY] User Has An Empty [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] And On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-322][Customer Side-Just-1PAY] User Has An Empty [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] And On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-323][Customer Side-Just-1PAY] User Has An Empty [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] And On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-324][Customer Side-Just-1PAY] User Has An Empty [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] And On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-325][Customer Side-Just-1PAY] User Has An Empty [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] And On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-326][Customer Side-Just-1PAY] User Has An Empty [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] And On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-327][Customer Side-Just-1PAY] User Has An Empty [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] And On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-328][Customer Side-Just-1PAY] User Has An Empty [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] And On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-329][Customer Side-Just-1PAY] User Has An Empty [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] And On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-330][Customer Side-Just-1PAY] User Has An Empty [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] And On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-331][Customer Side-Just-1PAY] User Has Blocked [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-332][Customer Side-Just-1PAY] User Has Blocked [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-333][Customer Side-Just-1PAY] User Has Blocked [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-334][Customer Side-Just-1PAY] User Has Blocked [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-335][Customer Side-Just-1PAY] User Has Blocked [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-336][Customer Side-Just-1PAY] User Has Blocked [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-337][Customer Side-Just-1PAY] User Has Blocked [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-338][Customer Side-Just-1PAY] User Has Blocked [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-339][Customer Side-Just-1PAY] User Has Blocked [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-340][Customer Side-Just-1PAY] User Has Blocked [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-341][Customer Side-Just-1PAY] User Has Blocked [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-342][Customer Side-Just-1PAY] User Has Blocked [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-343][Customer Side-Just-1PAY] User Has Blocked [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY, XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-344][Customer Side-Just-1PAY] User Has Blocked [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [1PAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-345][Customer Side-Just-1PAY] User Has Blocked [1PAY] Account And Business Has An Active [1PAY] Gateway With Repayment Option [XPAY] On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-346][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-347][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-348][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-349][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-350][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-351][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-352][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-353][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-354][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-355][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-356][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-357][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-358][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-359][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-360][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-361][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-362][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-363][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-364][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-365][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-366][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-367][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-368][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-369][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-370][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-371][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-372][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-373][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-374][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-375][Customer Side-1PAY-XPAY] User Has [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And Over The Balance Amount On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-376][Customer Side-1PAY-XPAY] User Has Two EXPIRED [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[0]
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-377][Customer Side-1PAY-XPAY] User Has Two EXPIRED [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[0]
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-378][Customer Side-1PAY-XPAY] User Has Two EXPIRED [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[0]
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-379][Customer Side-1PAY-XPAY] User Has First EXPIRED [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-380][Customer Side-1PAY-XPAY] User Has First EXPIRED [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-381][Customer Side-1PAY-XPAY] User Has First EXPIRED [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-382][Customer Side-1PAY-XPAY] User Has Second EXPIRED [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-383][Customer Side-1PAY-XPAY] User Has Second EXPIRED [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-384][Customer Side-1PAY-XPAY] User Has Second EXPIRED [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-385][Customer Side-1PAY-XPAY] User Has Two Empty [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel UPG
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance    credit_id=${credit_ids}[0]
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]    amount=60000
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-386][Customer Side-1PAY-XPAY] User Has Two Empty [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And On Channel UPG
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance    credit_id=${credit_ids}[0]
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]    amount=60000
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-387][Customer Side-1PAY-XPAY] User Has Two Empty [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And On Channel UPG
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance    credit_id=${credit_ids}[0]
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]    amount=60000
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-388][Customer Side-1PAY-XPAY] User Has First Empty [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel QR
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance    credit_id=${credit_ids}[0]
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-389][Customer Side-1PAY-XPAY] User Has First Empty [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And On Channel QR
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance    credit_id=${credit_ids}[0]
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-390][Customer Side-1PAY-XPAY] User Has First Empty [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And On Channel QR
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance    credit_id=${credit_ids}[0]
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-391][Customer Side-1PAY-XPAY] User Has Second Empty [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] And On Channel SMART_POS
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]    amount=60000
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-392][Customer Side-1PAY-XPAY] User Has Second Empty [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] And On Channel SMART_POS
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]    amount=60000
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-393][Customer Side-1PAY-XPAY] User Has Second Empty [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] And On Channel SMART_POS
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]    amount=60000
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Over Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-394][Customer Side-1PAY-XPAY] User Has Two Blocked [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Block Credit Account    credit_id=${credit_ids}[0]
    And Block Credit Account    credit_id=${credit_ids}[1]
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-395][Customer Side-1PAY-XPAY] User Has Two Blocked [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel UPG
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Block Credit Account    credit_id=${credit_ids}[0]
    And Block Credit Account    credit_id=${credit_ids}[1]
    And Set channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-396][Customer Side-1PAY-XPAY] User Has Two Blocked [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel UPG
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Block Credit Account    credit_id=${credit_ids}[0]
    And Block Credit Account    credit_id=${credit_ids}[1]
    And Set channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-397][Customer Side-1PAY-XPAY] User Has First Blocked [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel QR
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Block Credit Account    credit_id=${credit_ids}[0]
    And Set channel QR
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-398][Customer Side-1PAY-XPAY] User Has First Blocked [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel QR
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Block Credit Account    credit_id=${credit_ids}[0]
    And Set channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-399][Customer Side-1PAY-XPAY] User Has First Blocked [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel QR
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Block Credit Account    credit_id=${credit_ids}[0]
    And Set channel QR
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10001
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-400][Customer Side-1PAY-XPAY] User Has Second Blocked [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel SMART_POS
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Block Credit Account    credit_id=${credit_ids}[1]
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-401][Customer Side-1PAY-XPAY] User Has Second Blocked [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel SMART_POS
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Block Credit Account    credit_id=${credit_ids}[1]
    And Set channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=10000
    ...    expected_sufficiency=True
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-402][Customer Side-1PAY-XPAY] User Has Second Blocked [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel SMART_POS
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Block Credit Account    credit_id=${credit_ids}[1]
    And Set channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-403][Customer Side-1PAY-XPAY] User Has First Blocked Second Expired [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Block Credit Account    credit_id=${credit_ids}[0]
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-404][Customer Side-1PAY-XPAY] User Has First Blocked Second Empty [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]    amount=60000
    And Block Credit Account    credit_id=${credit_ids}[0]
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-405][Customer Side-1PAY-XPAY] User Has First Expired Second Blocked [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Block Credit Account    credit_id=${credit_ids}[1]
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-406][Customer Side-1PAY-XPAY] User Has First Expired Second Empty [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]    amount=60000
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-407][Customer Side-1PAY-XPAY] User Has First Empty Second Expired [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance    credit_id=${credit_ids}[0]
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-408][Customer Side-1PAY-XPAY] User Has First Empty Second Blocked [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance    credit_id=${credit_ids}[0]
    And Block Credit Account    credit_id=${credit_ids}[1]
    And Set channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-409][Customer Side-1PAY-XPAY] User Has First Blocked Second Expired [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Block Credit Account    credit_id=${credit_ids}[0]
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-410][Customer Side-1PAY-XPAY] User Has First Blocked Second Empty [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]    amount=60000
    And Block Credit Account    credit_id=${credit_ids}[0]
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-411][Customer Side-1PAY-XPAY] User Has First Expired Second Blocked [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Block Credit Account    credit_id=${credit_ids}[1]
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-412][Customer Side-1PAY-XPAY] User Has First Expired Second Empty [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]    amount=60000
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-413][Customer Side-1PAY-XPAY] User Has First Empty Second Expired [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance    credit_id=${credit_ids}[0]
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-414][Customer Side-1PAY-XPAY] User Has First Empty Second Blocked [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [XPAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance    credit_id=${credit_ids}[0]
    And Block Credit Account    credit_id=${credit_ids}[1]
    And Set channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-415][Customer Side-1PAY-XPAY] User Has First Blocked Second Expired [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Block Credit Account    credit_id=${credit_ids}[0]
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-416][Customer Side-1PAY-XPAY] User Has First Blocked Second Empty [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]    amount=60000
    And Block Credit Account    credit_id=${credit_ids}[0]
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-417][Customer Side-1PAY-XPAY] User Has First Expired Second Blocked [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Block Credit Account    credit_id=${credit_ids}[1]
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-418][Customer Side-1PAY-XPAY] User Has First Expired Second Empty [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]    amount=60000
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[0]
    And Empty Balance    credit_id=${credit_ids}[0]
    And Expire Account    credit_id=${credit_ids}[0]
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-419][Customer Side-1PAY-XPAY] User Has First Empty Second Expired [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance    credit_id=${credit_ids}[0]
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Activate All Gateways
    And Set Amount Less Than Balance
    And Perform An Offline Purchase    credit_id=${credit_ids}[1]
    And Empty Balance    credit_id=${credit_ids}[1]
    And Expire Account    credit_id=${credit_ids}[1]
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-420][Customer Side-1PAY-XPAY] User Has First Empty Second Blocked [1PAY, XPAY] Account And Business Has An Active [BPG] Gateway With Repayment Option [1PAY, XPAY] On Channel BARCODE
    [Tags]    severity:high
    Given Allocate No Fee 1 PAY AND No Fee XPAY
    And Set channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Activate All Gateways
    And Empty Balance    credit_id=${credit_ids}[0]
    And Block Credit Account    credit_id=${credit_ids}[1]
    And Set channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_BPG}
    ...    expected_balance=0
    ...    expected_sufficiency=False
    And Customer Payment Methods Should Have The Length    expected_length=1

[TC-106][Customer Side-CPG] User Has Schedule Close [CREDIT] Account And Business Has An Active [CPG] Gateway With Repayment Option [1PAY, XPAY] On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Call Schedule Close API
    And Set channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Amount Less Than Balance
    When PM Inquiry Customer API Is Called
    Then Business Must Be Usable
    And Customer Payment Methods Should Not Be Active For A Specified Method
    ...    payment_method=${LMS_CUSTOMER_PAYMENT_METHOD.PAYMENT_CPG}
    And Customer Payment Methods Should Have The Length    expected_length=1