*** Settings ***
Resource            steps/LMS/credit-core/inquiry-step.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001][Repayment Option Assessment] User Has [1PAY] account When Business Has [No] Active Gateway On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Disable
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty

[TC-002][Repayment Option Assessment] User Has [No] account When Business Has [No] Active Gateway On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Disable
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty

[TC-003][Repayment Option Assessment] User Has [No] account When Business repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Close Account Via Credit Id
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-004][Repayment Option Assessment] User Has [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-005][Repayment Option Assessment] User Has [1PAY] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-006][Repayment Option Assessment] User Has [1PAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-007][Repayment Option Assessment] User Has [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-008][Repayment Option Assessment] User Has [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-009][Repayment Option Assessment] User Has [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:high
    Given Allocate No Fee XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-010][Repayment Option Assessment] User Has [1PAY, XPAY, CCREDIT, INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:high    robot:skip
    Given Allocate No Fee 1 PAY AND No Fee XPAY AND No Fee Saderat CCREDIT AND No Fee INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-011][Repayment Option Assessment] User Has [1PAY, XPAY, CCREDIT, INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:high    robot:skip
    Given Allocate No Fee 1 PAY AND No Fee XPAY AND No Fee Saderat CCREDIT AND No Fee INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=3
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0','1','2']}}
    And Inquiry List Status Must Be Sufficient

[TC-012][Basic Functionality Assessment] User Has [1PAY, XPAY, CCREDIT, INSTALLMENT_SALE] account When Business Has An Active Gateway On Channel LINUX_POS
    [Tags]    severity:high    robot:skip
    Given Allocate No Fee 1 PAY AND No Fee XPAY AND No Fee Saderat CCREDIT AND No Fee INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=4
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0','0','1','2']}}
    And Inquiry List Status Must Be Sufficient

[TC-013][Product Type Assessment] User Has [1PAY, XPAY, CCREDIT, INSTALLMENT_SALE] account When Business Has An Active Gateway On Channel LINUX_POS And No Product Type
    [Tags]    severity:high    robot:skip
    Given Allocate No Fee 1 PAY AND No Fee XPAY AND No Fee Saderat CCREDIT AND No Fee INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type EMPTY
    And Credit Gateway Activate
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=4
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0','0','1','2']}}
    And Inquiry List Status Must Be Sufficient

[TC-014][Product Type Assessment] User Has [1PAY, XPAY, CCREDIT, INSTALLMENT_SALE] account When Business Has An Active Gateway On Channel LINUX_POS And Invalid Product Type
    [Tags]    severity:high    robot:skip
    Given Allocate No Fee 1 PAY AND No Fee XPAY AND No Fee Saderat CCREDIT AND No Fee INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    And Update Fund Provider To Not Include Product Type CONSUMPTION GOODS
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=3
    And Credit Gateway Disable
    And Update Fund Provider To Include Product Type CONSUMPTION GOODS
    And Service Type Must Be Accurate    expected_service_types=${{['0','0','2']}}
    And Inquiry List Status Must Be Sufficient

[TC-015][Basic Functionality Assessment] User Has [1PAY, XPAY, CCREDIT, INSTALLMENT_SALE] account When Business Has An Active Gateway On Channel LINUX_POS But Cheque Eligible Is False
    [Tags]    severity:high    robot:skip
    Given Allocate No Fee 1 PAY AND No Fee XPAY AND No Fee Saderat CCREDIT AND No Fee INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Amount Less Than Balance
    And Set Payment Gateway BPG
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    And Set Payment Gateway ISPG
    And Credit Gateway Activate
    When Inquiry API Is Called    cheque_Eligible=false
    Then Inquiry List Must Have The Length    expected_length=3
    And Service Type Must Be Accurate    expected_service_types=${{['0','0','1']}}
    And Inquiry List Status Must Be Sufficient
    And Credit Gateway Disable

[TC-016][Functionality Assessment] User Has Blocked [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-017][Functionality Assessment] User Has Blocked [1PAY] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-018][Functionality Assessment] User Has Blocked [1PAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-019][Functionality Assessment] User Has Blocked [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-020][Functionality Assessment] User Has Blocked [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-021][Functionality Assessment] User Has Blocked [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-022][Functionality Assessment] User Has Blocked [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-023][Functionality Assessment] User Has Blocked [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-024][Functionality Assessment] User Has Blocked [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-025][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-026][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-027][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-028][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-029][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-030][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-031][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-032][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-033][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-034][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-036][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-037][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-038][Functionality Assessment] User Has Blocked [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-039][Functionality Assessment] User Has Blocked [1PAY] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-040][Functionality Assessment] User Has Blocked [1PAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-041][Functionality Assessment] User Has Blocked [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-042][Functionality Assessment] User Has Blocked [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-043][Functionality Assessment] User Has Blocked [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-044][Functionality Assessment] User Has Blocked [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-045][Functionality Assessment] User Has Blocked [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-046][Functionality Assessment] User Has Blocked [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-047][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-048][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-049][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-050][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-051][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-052][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-053][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-054][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-055][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-056][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-057][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-058][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-059][Functionality Assessment] User Has Blocked [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-060][Functionality Assessment] User Has Blocked [1PAY] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-061][Functionality Assessment] User Has Blocked [1PAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-062][Functionality Assessment] User Has Blocked [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-063][Functionality Assessment] User Has Blocked [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-064][Functionality Assessment] User Has Blocked [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-065][Functionality Assessment] User Has Blocked [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-066][Functionality Assessment] User Has Blocked [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-067][Functionality Assessment] User Has Blocked [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-068][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-069][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-070][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-071][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-072][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-073][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-074][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-075][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-076][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-077][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-078][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-079][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-080][Functionality Assessment] User Has ACTIVE [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-081][Functionality Assessment] User Has ACTIVE [1PAY] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-082][Functionality Assessment] User Has ACTIVE [1PAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-083][Functionality Assessment] User Has ACTIVE [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-084][Functionality Assessment] User Has ACTIVE [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-085][Functionality Assessment] User Has ACTIVE [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-086][Functionality Assessment] User Has ACTIVE [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-087][Functionality Assessment] User Has ACTIVE [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-088][Functionality Assessment] User Has ACTIVE [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-089][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-090][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-091][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-092][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-093][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient

[TC-094][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient

[TC-095][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-096][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Insufficient

[TC-097][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Insufficient

[TC-098][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-099][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-100][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-101][Functionality Assessment] User Has ACTIVE [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-102][Functionality Assessment] User Has ACTIVE [1PAY] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-103][Functionality Assessment] User Has ACTIVE [1PAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-104][Functionality Assessment] User Has ACTIVE [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-105][Functionality Assessment] User Has ACTIVE [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-106][Functionality Assessment] User Has ACTIVE [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-107][Functionality Assessment] User Has ACTIVE [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-108][Functionality Assessment] User Has ACTIVE [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-109][Functionality Assessment] User Has ACTIVE [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-110][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-111][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-112][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-113][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-114][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-115][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-116][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-117][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-118][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-119][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-120][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-121][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-122][Functionality Assessment] User Has ACTIVE [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-123][Functionality Assessment] User Has ACTIVE [1PAY] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-124][Functionality Assessment] User Has ACTIVE [1PAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-125][Functionality Assessment] User Has ACTIVE [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-126][Functionality Assessment] User Has ACTIVE [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-127][Functionality Assessment] User Has ACTIVE [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-128][Functionality Assessment] User Has ACTIVE [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-129][Functionality Assessment] User Has ACTIVE [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-130][Functionality Assessment] User Has ACTIVE [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-131][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-132][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-133][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-134][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-135][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-136][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-137][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-138][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-139][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-140][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-141][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-142][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-143][Functionality Assessment] User Has Blocked [1PAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-144][Functionality Assessment] User Has Blocked [1PAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-145][Functionality Assessment] User Has Blocked [1PAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-146][Functionality Assessment] User Has Blocked [XPAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-147][Functionality Assessment] User Has Blocked [XPAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-148][Functionality Assessment] User Has Blocked [XPAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-149][Functionality Assessment] User Has Blocked [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-150][Functionality Assessment] User Has Blocked [CREDIT] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-151][Functionality Assessment] User Has Blocked [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-152][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-153][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-154][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-155][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-156][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-157][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-158][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-159][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-160][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-161][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-162][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-163][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-164][Functionality Assessment] User Has Blocked [1PAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-165][Functionality Assessment] User Has Blocked [1PAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-166][Functionality Assessment] User Has Blocked [1PAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-167][Functionality Assessment] User Has Blocked [XPAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-168][Functionality Assessment] User Has Blocked [XPAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-169][Functionality Assessment] User Has Blocked [XPAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-170][Functionality Assessment] User Has Blocked [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-171][Functionality Assessment] User Has Blocked [CREDIT] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-172][Functionality Assessment] User Has Blocked [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-173][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-174][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-175][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-176][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-177][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-178][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-179][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-180][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-181][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-182][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-183][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-184][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-185][Functionality Assessment] User Has Blocked [1PAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-186][Functionality Assessment] User Has Blocked [1PAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-187][Functionality Assessment] User Has Blocked [1PAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-188][Functionality Assessment] User Has Blocked [XPAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-189][Functionality Assessment] User Has Blocked [XPAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-190][Functionality Assessment] User Has Blocked [XPAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-191][Functionality Assessment] User Has Blocked [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-192][Functionality Assessment] User Has Blocked [CREDIT] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-193][Functionality Assessment] User Has Blocked [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-194][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-195][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-196][Functionality Assessment] User Has Blocked [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-197][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-198][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-199][Functionality Assessment] User Has Blocked Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-200][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-201][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-202][Functionality Assessment] User Has Blocked Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable

[TC-203][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-204][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-205][Functionality Assessment] User Has Blocked Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Block Credit Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable

[TC-206][Functionality Assessment] User Has ACTIVE [1PAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient

[TC-207][Functionality Assessment] User Has ACTIVE [1PAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-208][Functionality Assessment] User Has ACTIVE [1PAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient

[TC-209][Functionality Assessment] User Has ACTIVE [XPAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-210][Functionality Assessment] User Has ACTIVE [XPAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient

[TC-211][Functionality Assessment] User Has ACTIVE [XPAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient

[TC-212][Functionality Assessment] User Has ACTIVE [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-213][Functionality Assessment] User Has ACTIVE [CREDIT] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Insufficient

[TC-214][Functionality Assessment] User Has ACTIVE [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Insufficient

[TC-215][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-216][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Insufficient

[TC-217][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Insufficient

[TC-218][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-219][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient

[TC-220][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient

[TC-221][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-223][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Insufficient

[TC-224][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Insufficient

[TC-225][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-226][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Insufficient

[TC-227][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Insufficient

[TC-228][Functionality Assessment] User Has ACTIVE [1PAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-229][Functionality Assessment] User Has ACTIVE [1PAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-230][Functionality Assessment] User Has ACTIVE [1PAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-231][Functionality Assessment] User Has ACTIVE [XPAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-232][Functionality Assessment] User Has ACTIVE [XPAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-233][Functionality Assessment] User Has ACTIVE [XPAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-234][Functionality Assessment] User Has ACTIVE [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-235][Functionality Assessment] User Has ACTIVE [CREDIT] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-236][Functionality Assessment] User Has ACTIVE [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-237][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-238][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-239][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-240][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-241][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-242][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-243][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-244][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-245][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-246][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-247][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-248][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-249][Functionality Assessment] User Has ACTIVE [1PAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-250][Functionality Assessment] User Has ACTIVE [1PAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-251][Functionality Assessment] User Has ACTIVE [1PAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-252][Functionality Assessment] User Has ACTIVE [XPAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-253][Functionality Assessment] User Has ACTIVE [XPAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-254][Functionality Assessment] User Has ACTIVE [XPAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-255][Functionality Assessment] User Has ACTIVE [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-256][Functionality Assessment] User Has ACTIVE [CREDIT] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-257][Functionality Assessment] User Has ACTIVE [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-258][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-259][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-260][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-261][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-262][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-263][Functionality Assessment] User Has ACTIVE Fee On Purchase [XPAY] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient

[TC-264][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-265][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-266][Functionality Assessment] User Has ACTIVE Fee On Purchase [CREDIT] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Sufficient

[TC-267][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-268][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-269][Functionality Assessment] User Has ACTIVE Fee On Purchase [INSTALLMENT_SALE] account When Amount Over Balance Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-270][Zero Balance Assessment] User Has EMPTY [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Activate All Gateways
    And Empty Balance
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient

[TC-271][Zero Balance Assessment] User Has EMPTY [1PAY] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty

[TC-272][Zero Balance Assessment] User Has EMPTY [1PAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient

[TC-273][Online Channel Assessment] User Has [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel UPG
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Status Code Must Be 422
    And Credit Gateway Disable

[TC-274][Online Channel Assessment] User Has [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel QR
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Status Code Must Be 422
    And Credit Gateway Disable

[TC-275][API Body Assessment] User Has [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS No User Name
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called    user_id=${EMPTY}
    Then Status Code Must Be 422
    And Credit Gateway Disable

[TC-278][API Body Assessment] User Has [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS No Amount No Business Id and No Channel
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient
    And Credit Gateway Disable

[TC-279][Functionality Assessment] User Has Expired [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Activate All Gateways
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-280][Functionality Assessment] User Has Expired [1PAY] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Activate All Gateways
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty

[TC-281][Functionality Assessment] User Has Expired [1PAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Activate All Gateways
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-282][Functionality Assessment] User Has Expired [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Activate All Gateways
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty

[TC-283][Functionality Assessment] User Has Expired [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Activate All Gateways
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-284][Functionality Assessment] User Has Expired [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-285][Functionality Assessment] User Has Expired [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Empty Balance
    And Expire Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-286][Functionality Assessment] User Has Expired [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable
    And Credit Gateway Disable

[TC-287][Functionality Assessment] User Has Expired [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable
    And Credit Gateway Disable

[TC-288][Functionality Assessment] User Has Expired [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-289][Functionality Assessment] User Has Expired [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set Payment Channel BARCODE
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable
    And Credit Gateway Disable

[TC-290][Functionality Assessment] User Has Expired [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable
    And Credit Gateway Disable

[TC-291][Functionality Assessment] User Has Expired [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-292][Functionality Assessment] User Has Expired [1PAY] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty

[TC-293][Functionality Assessment] User Has Expired [1PAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-294][Functionality Assessment] User Has Expired [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee XPAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty

[TC-295][Functionality Assessment] User Has Expired [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-296][Functionality Assessment] User Has Expired [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-297][Functionality Assessment] User Has Expired [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-298][Functionality Assessment] User Has Expired [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable
    And Credit Gateway Disable

[TC-299][Functionality Assessment] User Has Expired [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable
    And Credit Gateway Disable

[TC-300][Functionality Assessment] User Has Expired [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-301][Functionality Assessment] User Has Expired [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable
    And Credit Gateway Disable

[TC-302][Functionality Assessment] User Has Expired [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel SMART_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable
    And Credit Gateway Disable

[TC-303][Functionality Assessment] User Has Expired [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-304][Functionality Assessment] User Has Expired [1PAY] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty

[TC-306][Functionality Assessment] User Has Expired [1PAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-307][Functionality Assessment] User Has Expired [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty

[TC-308][Functionality Assessment] User Has Expired [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-309][Functionality Assessment] User Has Expired [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-310][Functionality Assessment] User Has Expired [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-311][Functionality Assessment] User Has Expired [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable
    And Credit Gateway Disable

[TC-312][Functionality Assessment] User Has Expired [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Unusable
    And Credit Gateway Disable

[TC-313][Functionality Assessment] User Has Expired [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-314][Functionality Assessment] User Has Expired [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable
    And Credit Gateway Disable

[TC-315][Functionality Assessment] User Has Expired [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Empty Balance
    And Expire Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Unusable
    And Credit Gateway Disable

[TC-316][Zero Balance Assessment] User Has EMPTY [XPAY] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty

[TC-317][Zero Balance Assessment] User Has EMPTY [XPAY] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient

[TC-318][Zero Balance Assessment] User Has EMPTY [XPAY] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Activate All Gateways
    And Empty Balance
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient

[TC-319][Zero Balance Assessment] User Has EMPTY [CREDIT] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Activate All Gateways
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty

[TC-320][Zero Balance Assessment] User Has EMPTY [CREDIT] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Insufficient

[TC-321][Zero Balance Assessment] User Has EMPTY [CREDIT] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Activate All Gateways
    And Empty Balance
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Insufficient

[TC-322][Zero Balance Assessment] User Has EMPTY [INSTALLMENT_SALE] account When Business Has repayment option [1PAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Activate All Gateways
    And Empty Balance
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty

[TC-323][Zero Balance Assessment] User Has EMPTY [INSTALLMENT_SALE] account When Business Has repayment option [XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Activate All Gateways
    And Empty Balance
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-324][Zero Balance Assessment] User Has EMPTY [INSTALLMENT_SALE] account When Business Has repayment option [1PAY, XPAY] Active Gateway On Channel LINUX_POS
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Channel LINUX_POS
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Activate All Gateways
    And Empty Balance
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['2']}}
    And Inquiry List Status Must Be Sufficient

[TC-325][Functionality Assessment] User Has Schedule Close [1PAY] account When Business Has repayment option [1PAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Call Schedule Close API
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Unusable

[TC-326][Functionality Assessment] User Has ACTIVE [XPAY] account When Amount Over Balance And Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee XPAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient

[TC-327][Functionality Assessment] User Has ACTIVE [CREDIT] account When Amount Over Balance And Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway CPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['1']}}
    And Inquiry List Status Must Be Insufficient

[TC-328][Functionality Assessment] User Has ACTIVE [INSTALLMENT_SALE] account When Amount Over Balance And Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Credit Gateway Disable
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient

[TC-329][Functionality Assessment] User Has ACTIVE [1PAY] account When Amount Over Balance And Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient
    And Credit Gateway Disable

[TC-330][Functionality Assessment] User Has ACTIVE [1PAY] account When Amount Less Than Balance And Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel PLATFORM_CARD
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Sufficient
    And Credit Gateway Disable

[TC-331][Functionality Assessment] User Has ACTIVE [1PAY] account When Amount Over Than Balance And Business Has repayment option [1PAY, XPAY] Active Gateway On Channel BARCODE
    [Tags]    severity:low
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel PLATFORM_CARD
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Service Type Must Be Accurate    expected_service_types=${{['0']}}
    And Inquiry List Status Must Be Insufficient
    And Credit Gateway Disable