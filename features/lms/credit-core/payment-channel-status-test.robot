*** Settings ***
Resource            steps/LMS/credit-core/inquiry-step.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount


*** Test Cases ***
# ============================================================================
# API CHANNEL (Payment Channel = 0) - FULL CREDIT PURCHASE ONLY
# ============================================================================

[TC-001][API][1PAY] Full Credit Purchase With Sufficient Balance
    [Tags]    severity:high    api_channel    account_1pay
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel API
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Sufficient    # SUFFICIENT
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-002][API][1PAY] Partial Purchase Attempt - Should Return SUFFICIENT
    [Tags]    severity:high    api_channel    account_1pay
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel API
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Sufficient    # SUFFICIENT
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-003][API][1PAY] Over Purchase Attempt - Should Return INSUFFICIENT
    [Tags]    severity:high    api_channel    account_1pay
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel API
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Insufficient    # INSUFFICIENT
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-004][API][1PAY] Blocked Account - Should Return UNUSABLE
    [Tags]    severity:high    api_channel    account_1pay
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel API
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Block Credit Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Unusable    # UNUSABLE
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-005][API][1PAY] Expired Account - Should Return UNUSABLE
    [Tags]    severity:high    api_channel    account_1pay
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel API
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Expire Account
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Unusable    # UNUSABLE
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-006][API][1PAY] Zero Balance Account - Should Return INSUFFICIENT
    [Tags]    severity:high    api_channel    account_1pay
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel API
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Insufficient    # INSUFFICIENT
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-007][API][XPAY] Full Credit Purchase With Sufficient Balance
    [Tags]    severity:high    api_channel    account_xpay
    Given Allocate No Fee XPAY Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Unusable    # UNUSABLE
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-008][API][XPAY] Partial Purchase Attempt - Should Return INSUFFICIENT
    [Tags]    severity:high    api_channel    account_xpay
    Given Allocate No Fee XPAY Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Unusable    # INSUFFICIENT
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-009][API][CREDIT] Full Credit Purchase With Sufficient Balance
    [Tags]    severity:high    api_channel    account_credit
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Sufficient    # SUFFICIENT
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-010][API][CREDIT] Partial Purchase Attempt - Should Return SUFFICIENT
    [Tags]    severity:high    api_channel    account_credit
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Sufficient    # SUFFICIENT
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-011][API][INSTALLMENT_SALE] Full Credit Purchase With Sufficient Balance
    [Tags]    severity:high    api_channel    account_installment    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Sufficient    # SUFFICIENT
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-012][API][INSTALLMENT_SALE] Partial Purchase Attempt - Should Return Empty List
    [Tags]    severity:high    api_channel    account_installment    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-013][API][INSTALLMENT_SALE] Over Purchase Attempt - Should Return Empty List
    [Tags]    severity:high    api_channel    account_installment    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

# ============================================================================
# NON-API CHANNELS (Payment Channel ≠ 0) - FLEXIBLE PURCHASE
# ============================================================================

[TC-014][NonAPI][1PAY] Active Account With Any Amount - Should Return ACTIVE
    [Tags]    severity:high    non_api_channel    account_1pay
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-015][NonAPI][1PAY] Blocked Account - Should Return BLOCK
    [Tags]    severity:high    non_api_channel    account_1pay
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Block Credit Account
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-016][NonAPI][1PAY] Closed Account - Should Return CLOSE
    [Tags]    severity:high    non_api_channel    account_1pay
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Close Account Via Credit Id
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-017][NonAPI][1PAY] Inactive Account - Should Return INACTIVE
    [Tags]    severity:high    non_api_channel    account_1pay
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Set Account To Inactive
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-018][NonAPI][XPAY] Active Account With Any Amount - Should Return ACTIVE
    [Tags]    severity:high    non_api_channel    account_xpay
    Given Allocate No Fee XPAY Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-019][NonAPI][CREDIT] Active Account With Any Amount - Should Return ACTIVE
    [Tags]    severity:high    non_api_channel    account_credit
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-020][NonAPI][INSTALLMENT_SALE] Exact Balance Purchase - Should Return ACTIVE
    [Tags]    severity:high    non_api_channel    account_installment    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-021][NonAPI][INSTALLMENT_SALE] Partial Purchase Attempt - Should Return Empty List
    [Tags]    severity:high    non_api_channel    account_installment    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-022][NonAPI][INSTALLMENT_SALE] Over Purchase Attempt - Should Return Empty List
    [Tags]    severity:high    non_api_channel    account_installment    robot:skip
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Over Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

# ============================================================================
# REPAYMENT OPTION MISMATCH SCENARIOS
# ============================================================================

[TC-023][Mismatch][API] 1PAY Account With XPAY Repayment Option
    [Tags]    severity:high    repayment_mismatch    api_channel
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-024][Mismatch][API] XPAY Account With 1PAY Repayment Option
    [Tags]    severity:high    repayment_mismatch    api_channel
    Given Allocate No Fee XPAY Account
    And Set Payment Channel API
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-025][Mismatch][API] CREDIT Account With 1PAY Repayment Option
    [Tags]    severity:high    repayment_mismatch    api_channel
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel API
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-026][Mismatch][API] INSTALLMENT_SALE Account With 1PAY Repayment Option
    [Tags]    severity:high    repayment_mismatch    api_channel
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel API
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

[TC-027][Mismatch][NonAPI] 1PAY Account With XPAY Repayment Option
    [Tags]    severity:high    repayment_mismatch    non_api_channel
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-028][Mismatch][NonAPI] XPAY Account With 1PAY Repayment Option
    [Tags]    severity:high    repayment_mismatch    non_api_channel
    Given Allocate No Fee XPAY Account
    And Set Payment Channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-029][Mismatch][NonAPI] CREDIT Account With 1PAY Repayment Option
    [Tags]    severity:high    repayment_mismatch    non_api_channel
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-030][Mismatch][NonAPI] INSTALLMENT_SALE Account With 1PAY Repayment Option
    [Tags]    severity:high    repayment_mismatch    non_api_channel
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

# ============================================================================
# DIFFERENT PAYMENT CHANNELS TESTING
# ============================================================================

[TC-031][Channels][UPG] Active 1PAY Account
    [Tags]    severity:medium    payment_channels
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-032][Channels][SMART_POS] Active 1PAY Account
    [Tags]    severity:medium    payment_channels
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel SMART_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Sufficient    # ACTIVE
    And Remain Balance Must Be Accurate    expected_balance=${DEFAULT_ALLOCATION_AMOUNT}
    And Credit Gateway Disable

[TC-033][Channels][QR] Active 1PAY Account
    [Tags]    severity:medium    payment_channels
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel QR
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-034][Channels][BARCODE] Active 1PAY Account
    [Tags]    severity:medium    payment_channels
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel BARCODE
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Sufficient    # ACTIVE
    And Remain Balance Must Be Accurate    expected_balance=${DEFAULT_ALLOCATION_AMOUNT}
    And Credit Gateway Disable

[TC-035][Channels][LINUX_POS] Active 1PAY Account
    [Tags]    severity:medium    payment_channels
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel LINUX_POS
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Sufficient    # ACTIVE
    And Remain Balance Must Be Accurate    expected_balance=${DEFAULT_ALLOCATION_AMOUNT}
    And Credit Gateway Disable

# ============================================================================
# EDGE CASES AND BOUNDARY TESTING
# ============================================================================

[TC-036][EdgeCase] Zero Balance And Zero Amount In API Channel
    [Tags]    severity:medium    edge_case
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel API
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Zero
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-037][EdgeCase] Zero Balance And Positive Amount In API Channel
    [Tags]    severity:medium    edge_case
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel API
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Empty Balance
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Insufficient    # INSUFFICIENT
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-038][EdgeCase] Negative Amount In API Channel
    [Tags]    severity:medium    edge_case
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel API
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Negative Amount
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Status Code Must Be 422
    And Credit Gateway Disable

# ============================================================================
# MULTIPLE ACCOUNT TYPES TESTING
# ============================================================================

[TC-039][MultipleAccounts][API] Multiple Account Types With Full Credit Purchase
    [Tags]    severity:high    multiple_accounts    api_channel
    Given Allocate No Fee 1 PAY AND No Fee XPAY AND No Fee CCREDIT Account
    And Set Payment Channel API
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=3
    And Inquiry Item Status Must Be    index=0    expected_status=1    # SUFFICIENT
    And Inquiry Item Status Must Be    index=1    expected_status=0    # UNUSABLE
    And Inquiry Item Status Must Be    index=2    expected_status=1    # SUFFICIENT
    And All Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-040][MultipleAccounts][NonAPI] Multiple Account Types With Flexible Purchase
    [Tags]    severity:high    multiple_accounts    non_api_channel
    Given Allocate No Fee 1 PAY AND No Fee XPAY AND No Fee CCREDIT Account
    And Set Payment Channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-041][MultipleAccounts][NonAPI] Mixed Account Statuses
    [Tags]    severity:high    multiple_accounts    non_api_channel
    Given Allocate No Fee 1 PAY AND No Fee XPAY AND No Fee CCREDIT Account
    And Block Credit Account
    And Close Account Via Credit Id
    And Set Account To Inactive
    And Set Payment Channel UPG
    And Set Repayment Option 1PAY And XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    And Set Payment Gateway CPG
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

# ============================================================================
# INSTALLMENT SALE SPECIFIC TESTING (Separate from CREDIT)
# ============================================================================

[TC-042][InstallmentSale][API] INSTALLMENT_SALE Account With Full Credit Purchase
    [Tags]    severity:high    installment_sale    api_channel
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Sufficient    # SUFFICIENT
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-043][InstallmentSale][NonAPI] INSTALLMENT_SALE Account With Exact Balance
    [Tags]    severity:high    installment_sale    non_api_channel
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-044][InstallmentSale][NonAPI] INSTALLMENT_SALE Account With Partial Balance - Should Return Empty List
    [Tags]    severity:high    installment_sale    non_api_channel
    Given Allocate No Fee INSTALLMENT SALES Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

# ============================================================================
# PRODUCT TYPE TESTING
# ============================================================================

[TC-045][ProductType][CONSUMPTION] 1PAY Account With Consumption Goods
    [Tags]    severity:medium    product_type
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-046][ProductType][DURABLE] 1PAY Account With Durable Goods
    [Tags]    severity:medium    product_type
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type DURABLE GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-047][ProductType][SERVICE] 1PAY Account With Service
    [Tags]    severity:medium    product_type
    Given Allocate No Fee 1PAY Account
    And Set Payment Channel UPG
    And Set Repayment Option 1PAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type SERVICE
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

# ============================================================================
# FEE-BASED ACCOUNT TESTING (Fee is cash, doesn't affect credit balance)
# ============================================================================

[TC-048][FeeAccount][XPAY] Fee On Purchase Account - Full Credit Purchase
    [Tags]    severity:medium    fee_account
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-049][FeeAccount][XPAY] Fee On Purchase Account - Partial Purchase Should Return ACTIVE
    [Tags]    severity:high    fee_account    non_api_channel
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-050][FeeAccount][CREDIT] Fee On Purchase Account - Full Credit Purchase
    [Tags]    severity:medium    fee_account
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-051][FeeAccount][CREDIT] Fee On Purchase Account - Partial Purchase Should Return ACTIVE
    [Tags]    severity:high    fee_account    non_api_channel
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-052][FeeAccount][INSTALLMENT_SALE] Fee On Purchase Account - Full Credit Purchase
    [Tags]    severity:medium    fee_account    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-053][FeeAccount][INSTALLMENT_SALE] Fee On Purchase Account - Partial Purchase Should Return Empty List
    [Tags]    severity:high    fee_account    non_api_channel    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

# ============================================================================
# NO-FEE vs FEE ACCOUNT COMPARISON (Fee doesn't affect credit balance)
# ============================================================================

[TC-054][Comparison][XPAY] No-Fee vs Fee Account - Partial Purchase in API Channel
    [Tags]    severity:high    comparison    api_channel
    Given Allocate No Fee XPAY Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Unusable    # UNUSABLE (API channel doesn't allow partial)
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-055][Comparison][XPAY] No-Fee vs Fee Account - Partial Purchase in Non-API Channel
    [Tags]    severity:high    comparison    non_api_channel
    Given Allocate No Fee XPAY Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-056][Comparison][XPAY] Fee Account - Partial Purchase in Non-API Channel
    [Tags]    severity:high    comparison    non_api_channel
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-057][Comparison][CREDIT] No-Fee vs Fee Account - Partial Purchase in Non-API Channel
    [Tags]    severity:high    comparison    non_api_channel
    Given Allocate No Fee CCREDIT Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

[TC-058][Comparison][CREDIT] Fee Account - Partial Purchase in Non-API Channel
    [Tags]    severity:high    comparison    non_api_channel
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel UPG
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    And Status Code Must Be 422
    And Credit Gateway Disable

# ============================================================================
# API CHANNEL WITH FEE ON PURCHASE (API doesn't support cash payments)
# ============================================================================

[TC-059][API][FeeAccount][XPAY] Fee On Purchase Account - Full Credit Purchase
    [Tags]    severity:high    api_channel    fee_account
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Unusable    # UNUSABLE (full credit purchase)
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-060][API][FeeAccount][XPAY] Fee On Purchase Account - Partial Purchase Should Return INSUFFICIENT
    [Tags]    severity:high    api_channel    fee_account
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Unusable    # UNUSABLE (API channel doesn't allow partial + fee requires cash)
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-061][API][FeeAccount][CREDIT] Fee On Purchase Account - Full Credit Purchase
    [Tags]    severity:high    api_channel    fee_account
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Unusable    # UNUSABLE (API channel doesn't allow partial + fee requires cash)
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-062][API][FeeAccount][CREDIT] Fee On Purchase Account - Partial Purchase Should Return INSUFFICIENT
    [Tags]    severity:high    api_channel    fee_account
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Unusable    # UNUSABLE (API channel doesn't allow partial + fee requires cash)
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-063][API][FeeAccount][INSTALLMENT_SALE] Fee On Purchase Account - Full Credit Purchase
    [Tags]    severity:high    api_channel    fee_account    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Equal To Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Sufficient    # SUFFICIENT (full credit purchase)
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-064][API][FeeAccount][INSTALLMENT_SALE] Fee On Purchase Account - Partial Purchase Should Return Empty List
    [Tags]    severity:high    api_channel    fee_account    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable

# ============================================================================
# API vs NON-API CHANNEL COMPARISON WITH FEE ACCOUNTS
# ============================================================================

[TC-065][Comparison][APIvsNonAPI][XPAY] Fee Account - Partial Purchase Comparison
    [Tags]    severity:high    comparison    api_vs_nonapi
    Given Allocate Fee On Purchase XPAY Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway BPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Unusable    # UNUSABLE (API channel doesn't support cash fees)
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-066][Comparison][APIvsNonAPI][CREDIT] Fee Account - Partial Purchase Comparison
    [Tags]    severity:high    comparison    api_vs_nonapi
    Given Allocate Fee On Purchase CCREDIT Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway CPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Have The Length    expected_length=1
    And Inquiry List Status Must Be Unusable    # UNUSABLE (API channel doesn't support cash fees)
    And Remain Balance Must Be Null
    And Credit Gateway Disable

[TC-067][Comparison][APIvsNonAPI][INSTALLMENT_SALE] Fee Account - Partial Purchase Comparison
    [Tags]    severity:high    comparison    api_vs_nonapi    robot:skip
    Given Allocate Fee On Purchase INSTALLMENT SALES Account
    And Set Payment Channel API
    And Set Repayment Option XPAY
    And Set Payment Gateway ISPG
    And Set Amount Less Than Balance
    And Set Product Type CONSUMPTION GOODS
    And Credit Gateway Activate
    When Inquiry API Is Called
    Then Inquiry List Must Be Empty
    And Credit Gateway Disable
