*** Settings ***
Resource            steps/LMS/credit-core/offline-purchase-step.resource

Test Setup          Initialize Merchant
Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] Making Complete Purchase On No Fee BNPl
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Complete A Purchase    ${user_id}    ${credit_ids}[0]    terminal_id=123456789
    Then Get Confirmed Status From Credit Management DB And Report Management DB And Purchase Has Terminal Id And RRN
    ...    tracking_code=${tracking_code}
    And The Gateway Is Disabled

[TC-002] Making Complete Purchase With Fee On Purchase BNPl
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Complete A Purchase    ${user_id}    ${credit_ids}[0]
    Then Get Confirmed Status From Credit Management DB    tracking_code=${tracking_code}
    And The Gateway Is Disabled

[TC-003] Making Complete Purchase With Fee On Purchase CCredit
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Complete A Purchase    ${user_id}    ${credit_ids}[0]
    Then Get Confirmed Status From Credit Management DB    tracking_code=${tracking_code}
    And The Gateway Is Disabled

[TC-004] Making Complete Purchase On Installment Sale Account Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then Get Confirmed Status From Credit Management DB    tracking_code=${tracking_code}
    And The Gateway Is Disabled

[TC-005] Making Offline Purchase For (1pay) Blocked Account Channel Is Linux POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-006] Making Offline Purchase For (1pay) Expired Account Channel Is Linux POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-007] Making Offline Purchase For (1pay) With Zero Balance Channel Is Linux POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-008] Making Offline Purchase For (Xpay) Blocked Account Channel Is Linux POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-009] Making Offline Purchase For (Xpay) Expired Account Channel Is Linux POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-010] Making Offline Purchase For (Xpay) With Zero Balance Channel Is Linux POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-011] Making Offline Purchase For (Xpay) With Fee Blocked Account Channel Is Linux POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-012] Making Offline Purchase For (Xpay) With Fee Expired Account Channel Is Linux POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-013] Making Offline Purchase For (Xpay-Fee On Purchase) With Zero Balance Channel Is Linux POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-014] Making Offline Purchase For (1pay) Gateway Disable Channel Is Linux POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-015] Making Offline Purchase For (1pay) Gateway Disable & Account Blocked Channel Is Linux POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-016] Making Offline Purchase For (1pay) Gateway Disable & Account Expired Channel Is Linux POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired

[TC-017] Making Offline Purchase For (1pay) Gateway Disable & Zero Balance Channel Is Linux POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-018] Making Offline Purchase For (Xpay) Gateway Disable Channel Is Linux POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-019] Making Offline Purchase For (Xpay) Gateway Disable & Account Blocked Channel Is Linux POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-020] Making Offline Purchase For (Xpay) Gateway Disable & Account Expired Channel Is Linux POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-021] Making Offline Purchase For (Xpay) Gateway Disable & Zero Balance Channel Is Linux POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-022] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable Channel Is Linux POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-023] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Account Blocked Channel Is Linux POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-024] Making Offline Purchase For (Xpay-Fee On Purchase) Account Expired & Gateway Disable Channel Is Linux POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

###scenario check###

[TC-025] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Zero Balance Channel Is Linux POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-026] Making Offline Purchase For (1pay) Gateway Disable Befor Verify Channel Is Linux POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-027] Making Offline Purchase For (1pay) Gateway Disable & Account Blocked Before Verify Channel Is Linux POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-028] Making Offline Purchase For (1pay) Gateway Disable & Account Expired Before Verify Channel Is Linux POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-029] Making Offline Purchase For (1pay) Gateway Disable & Zero Balance Before Verify Channel Is Linux POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-030] Making Offline Purchase For (Xpay) Gateway Disable Before Verify Channel Is Linux POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-031] Making Offline Purchase For (Xpay) Gateway Disable & Account Blocked Before Verify Channel Is Linux POS
    Given Allocate No Fee BNPL Account(Xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-032] Making Offline Purchase For (Xpay) Gateway Disable & Account Expired Before Verify Channel Is Linux POS
    Given Allocate No Fee BNPL Account(Xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-033] Making Offline Purchase For (Xpay) Gateway Disable & Zero Balance Before Verify Channel Is Linux POS
    Given Allocate No Fee BNPL Account(Xpay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-034] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable Before Verify Channel Is Linux POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-035] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Account Blocked Before Verify Channel Is Linux POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-036] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Account Expired Before Verify Channel Is Linux POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-037] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Zero Balance Before Verify Channel Is Linux POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-038] Making Offline Purchase For (Credit) Active Account Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-039] Making Offline Purchase For (Credit) Blocked Account Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-040] Making Offline Purchase For (Credit) Expired Account Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-041] Making Offline Purchase For (Credit) With Zero Balance Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-042] Making Offline Purchase For (Credit-With Prepayment) Active Account Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-043] Making Offline Purchase For (Credit-Prepayment) Blocked Account Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-044] Making Offline Purchase For (Credit-Prepayment) Expired Account Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-045] Making Offline Purchase For (Credit-Prepayment) With Zero Balance Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-046] Making Offline Purchase For (Credit) With Fee Active Account Channel Is Linux POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-047] Making Offline Purchase For (Credit) With Fee Blocked Account Channel Is Linux POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-048] Making Offline Purchase For (Credit) With Fee Expired Account Channel Is Linux POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-049] Making Offline Purchase For (Credit-Fee On Purchase) With Zero Balance Channel Is Linux POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-050] Making Offline Purchase For (Credit) Gateway Disable & Account Blocked Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-051] Making Offline Purchase For (Credit) Account Expired & Gateway Disable Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired

###scenario check###

[TC-052] Making Offline Purchase For (Credit) Gateway Disable & Zero Balance Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-053] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-054] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Account Blocked Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-055] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Account Expired Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-056] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Zero Balance Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-057] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable Channel Is Linux POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-058] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Account Blocked Channel Is Linux POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-059] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Account Expired Channel Is Linux POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-060] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Zero Balance Channel Is Linux POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-061] Making Offline Purchase For (Credit) Gateway Disable Before Verify Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-062] Making Offline Purchase For (Credit) Gateway Disable & Account Blocked Before Verify Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-063] Making Offline Purchase For (Credit) Gateway Disable & Account Expired Before Verify Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-064] Making Offline Purchase For (Credit) Gateway Disable & Zero Balance Before Verify Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-065] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable Before Verify Channel Is Linux POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-066] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Account Blocked Before Verify Channel Is Linux POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-067] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Account Expired Before Verify Channel Is Linux POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-068] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Zero Balance Before Verify Channel Is Linux POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-069] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable Before Verify Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-070] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Account Blocked Before Verify Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-071] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Account Expired Before Verify Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-072] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Zero Balance Before Verify Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-073] Making Offline Purchase For (Installment Sale) Active Account Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-074] Making Offline Purchase For (Installment Sale) Blocked Account Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-075] Making Offline Purchase For (Installment Sale) Expired Account Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-076] Making Offline Purchase For (Installment Sale) With Zero Balance Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-077] Making Offline Purchase For (Installment Sale-With Prepayment) Active Account Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-078] Making Offline Purchase For (Installment Sale-Prepayment) Blocked Account Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-079] Making Offline Purchase For (Installment Sale-Prepayment) Expired Account Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-080] Making Offline Purchase For (Installment Sale-Prepayment) With Zero Balance Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-081] Making Offline Purchase For (Installment Sale) With Fee Active Account Channel Is Linux POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-082] Making Offline Purchase For (Installment Sale) With Fee Blocked Account Channel Is Linux POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-083] Making Offline Purchase For (Installment Sale) With Fee Expired Account Channel Is Linux POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-084] Making Offline Purchase For (Installment Sale-Fee On Purchase) With Zero Balance Channel Is Linux POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-085] Making Offline Purchase For (Installment Sale) Gateway Disable & Account Blocked Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-086] Making Offline Purchase For (Installment Sale) Gateway Disable & Account Expired Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired

[TC-087] Making Offline Purchase For (Installment Sale) Gateway Disable & Zero Balance Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-088] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-089] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Account Blocked Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-090] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Account Expired Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-091] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Zero Balance Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-092] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable Channel Is Linux POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-093] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Account Blocked Channel Is Linux POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-094] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Account Expired Channel Is Linux POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-095] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Zero Balance Channel Is Linux POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-096] Making Offline Purchase For (Installment Sale) Gateway Disable Before Verify Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-097] Making Offline Purchase For (Installment Sale) Gateway Disable & Account Blocked Before Verify Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-098] Making Offline Purchase For (Installment Sale) Gateway Disable & Account Expired Befor Verify Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-099] Making Offline Purchase For (Installment Sale) Gateway Disable & Zero Balance Before Verify Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-100] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable Before Verify Channel Is Linux POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-101] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Account Blocked Before Verify Channel Is Linux POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-102] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Account Expired Before Verify Channel Is Linux POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-103] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Zero Balance Before Verify Channel Is Linux POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-104] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable Before Verify Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-105] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Account Blocked Before Verify Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-106] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Account Expired Before Verify Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-107] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Zero Balance Before Verify Channel Is Linux POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-108] Making Complete Purchase On Installment Sale Account Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase
    ...    ${user_id}
    ...    ${credit_ids}[0]
    ...    amount=${DEFAULT_ALLOCATION_AMOUNT}
    ...    terminal_id=123456789
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then Get Confirmed Status From Credit Management DB And Report Management DB And Purchase Has Terminal Id And RRN
    ...    tracking_code=${tracking_code}
    And The Gateway Is Disabled

[TC-109] Making Offline Purchase For (1pay) Blocked Account Channel Is Smart POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-110] Making Offline Purchase For (1pay) Expired Account Channel Is Smart POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-111] Making Offline Purchase For (1pay) With Zero Balance Channel Is Smart POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-112] Making Offline Purchase For (Xpay) Blocked Account Channel Is Smart POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-113] Making Offline Purchase For (Xpay) Expired Account Channel Is Smart POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-114] Making Offline Purchase For (Xpay) With Zero Balance Channel Is Smart POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-115] Making Offline Purchase For (Xpay) With Fee Blocked Account Channel Is Smart POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-116] Making Offline Purchase For (Xpay) With Fee Expired Account Channel Is Smart POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-117] Making Offline Purchase For (Xpay-Fee On Purchase) With Zero Balance Channel Is Smart POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-118] Making Offline Purchase For (1pay) Gateway Disable Channel Is Smart POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-119] Making Offline Purchase For (1pay) Gateway Disable & Account Blocked Channel Is Smart POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-120] Making Offline Purchase For (1pay) Gateway Disable & Account Expired Channel Is Smart POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired

[TC-121] Making Offline Purchase For (1pay) Gateway Disable & Zero Balance Channel Is Smart POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-122] Making Offline Purchase For (Xpay) Gateway Disable Channel Is Smart POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-123] Making Offline Purchase For (Xpay) Gateway Disable & Account Blocked Channel Is Smart POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-124] Making Offline Purchase For (Xpay) Gateway Disable & Account Expired Channel Is Smart POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-125] Making Offline Purchase For (Xpay) Gateway Disable & Zero Balance Channel Is Smart POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-126] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable Channel Is Smart POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-127] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Account Blocked Channel Is Smart POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-128] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Account Expired Channel Is Smart POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-129] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Zero Balance Channel Is Smart POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-130] Making Offline Purchase For (1pay) Gateway Disable Before Verify Channel Is Smart POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-131] Making Offline Purchase For (1pay) Gateway Disable & Account Blocked Before Verify Channel Is Smart POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-132] Making Offline Purchase For (1pay) Gateway Disable & Account Expired Before Verify Channel Is Smart POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-133] Making Offline Purchase For (1pay) Gateway Disable & Zero Balance Before Verify Channel Is Smart POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-134] Making Offline Purchase For (Xpay) Gateway Disable Before Verify Channel Is Smart POS
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-135] Making Offline Purchase For (Xpay) Gateway Disable & Account Blocked Before Verify Channel Is Smart POS
    Given Allocate No Fee BNPL Account(Xpay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-136] Making Offline Purchase For (Xpay) Gateway Disable & Account Expired Before Verify Channel Is Smart POS
    Given Allocate No Fee BNPL Account(Xpay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-137] Making Offline Purchase For (Xpay) Gateway Disable & Zero Balance Before Verify Channel Is Smart POS
    Given Allocate No Fee BNPL Account(Xpay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-138] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable Before Verify Channel Is Smart POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-139] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Account Blocked Before Verify Channel Is Smart POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-140] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Account Expired Before Verify Channel Is Smart POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-141] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Zero Balance Before Verify Channel Is Smart POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-142] Making Offline Purchase For (Credit) Active Account Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-143] Making Offline Purchase For (Credit) Blocked Account Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-144] Making Offline Purchase For (Credit) Expired Account Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-145] Making Offline Purchase For (Credit) With Zero Balance Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-146] Making Offline Purchase For (Credit-With Prepayment) Active Account Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-147] Making Offline Purchase For (Credit-Prepayment) Blocked Account Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-148] Making Offline Purchase For (Credit-Prepayment) Expired Account Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-149] Making Offline Purchase For (Credit-Prepayment) With Zero Balance Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-150] Making Offline Purchase For (Credit) With Fee Active Account Channel Is Smart POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-151] Making Offline Purchase For (Credit) With Fee Blocked Account Channel Is Smart POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-152] Making Offline Purchase For (Credit) With Fee Expired Account Channel Is Smart POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-153] Making Offline Purchase For (Credit-Fee On Purchase) With Zero Balance Channel Is Smart POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-154] Making Offline Purchase For (Credit) Gateway Disable & Account Blocked Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist

[TC-155] Making Offline Purchase For (Credit) Gateway Disable & Account Expired Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired

[TC-156] Making Offline Purchase For (Credit) Gateway Disable & Zero Balance Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-157] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-158] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Account Blocked Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-159] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Account Expired Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-160] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Zero Balance Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-161] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable Channel Is Smart POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-162] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Account Blocked Channel Is Smart POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-163] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Account Expired Channel Is Smart POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-164] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Zero Balance Channel Is Smart POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-165] Making Offline Purchase For (Credit) Gateway Disable Before Verify Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-166] Making Offline Purchase For (Credit) Gateway Disable & Account Blocked Before Verify Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-167] Making Offline Purchase For (Credit) Gateway Disable & Account Expired Before Verify Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-168] Making Offline Purchase For (Credit) Gateway Disable & Zero Balance Before Verify Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-169] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable Before Verify Channel Is Smart POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-170] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Account Blocked Before Verify Channel Is Smart POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-171] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Account Expired Before Verify Channel Is Smart POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    and The Purchase Exist

[TC-172] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Zero Balance Before Verify Channel Is Smart POS
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-173] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable Before Verify Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-174] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Account Blocked Before Verify Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-175] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Account Expired Before Verify Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-176] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Zero Balance Before Verify Channel Is Smart POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-177] Making Offline Purchase For (Installment Sale) Active Account Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-178] Making Offline Purchase For (Installment Sale) Blocked Account Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-179] Making Offline Purchase For (Installment Sale) Expired Account Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-180] Making Offline Purchase For (Installment Sale) With Zero Balance Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-181] Making Offline Purchase For (Installment Sale-With Prepayment) Active Account Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-182] Making Offline Purchase For (Installment Sale-Prepayment) Blocked Account Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-183] Making Offline Purchase For (Installment Sale-Prepayment) Expired Account Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-184] Making Offline Purchase For (Installment Sale-Prepayment) With Zero Balance Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-185] Making Offline Purchase For (Installment Sale) With Fee Active Account Channel Is Smart POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-186] Making Offline Purchase For (Installment Sale) With Fee Blocked Account Channel Is Smart POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-187] Making Offline Purchase For (Installment Sale) With Fee Expired Account Channel Is Smart POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-188] Making Offline Purchase For (Installment Sale-Fee On Purchase) With Zero Balance Channel Is Smart POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-189] Making Offline Purchase For (Installment Sale) Gateway Disable & Account Blocked Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist

[TC-190] Making Offline Purchase For (Installment Sale) Gateway Disable & Account Expired Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired

[TC-191] Making Offline Purchase For (Installment Sale) Gateway Disable & Zero Balance Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-192] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-193] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Account Blocked Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-194] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Account Expired Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-195] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Zero Balance Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-196] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable Channel Is Smart POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-197] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Account Blocked Channel Is Smart POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-198] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Account Expired Channel Is Smart POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-199] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Zero Balance Channel Is Smart POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist

[TC-200] Making Offline Purchase For (Installment Sale) Gateway Disable Before Verify Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-201] Making Offline Purchase For (Installment Sale) Gateway Disable & Account Blocked Before Verify Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-202] Making Offline Purchase For (Installment Sale) Gateway Disable & Account Expired Before Verify Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-203] Making Offline Purchase For (Installment Sale) Gateway Disable & Zero Balance Before Verify Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-204] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable Before Verify Channel Is Smart POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-205] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Account Blocked Before Verify Channel Is Smart POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-206] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Account Expired Before Verify Channel Is Smart POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-207] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Zero Balance Before Verify Channel Is Smart POS
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-208] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable Before Verify Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-209] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Account Blocked Before Verify Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-210] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Account Expired Before Verify Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-211] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Zero Balance Before Verify Channel Is Smart POS
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-212] Making Complete Purchase On Installment Sale Account Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    Then Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And The Gateway Is Disabled
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    When Get Confirmed Status From Credit Management DB    tracking_code=${tracking_code}

[TC-213] Making Offline Purchase For (1pay) Blocked Account Channel Is Barcode
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-214] Making Offline Purchase For (1pay) Expired Account Channel Is Barcode
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-215] Making Offline Purchase For (1pay) With Zero Balance Channel Is Barcode
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-216] Making Offline Purchase For (Xpay) Blocked Account Channel Is Barcode
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-217] Making Offline Purchase For (Xpay) Expired Account Channel Is Barcode
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-218] Making Offline Purchase For (Xpay) With Zero Balance Channel Is Barcode
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-219] Making Offline Purchase For (Xpay) With Fee Blocked Account Channel Is Barcode
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-220] Making Offline Purchase For (Xpay) With Fee Expired Account Channel Is Barcode
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-221] Making Offline Purchase For (Xpay-Fee On Purchase) With Zero Balance Channel Is Barcode
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-222] Making Offline Purchase For (1pay) Gateway Disable Channel Is Barcode
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-223] Making Offline Purchase For (1pay) Gateway Disable & Account Blocked Channel Is Barcode
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-224] Making Offline Purchase For (1pay) Gateway Disable & Account Expired Channel Is Barcode
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired

[TC-225] Making Offline Purchase For (1pay) Gateway Disable & Zero Balance Channel Is Barcode
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-226] Making Offline Purchase For (Xpay) Gateway Disable Channel Is Barcode
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-227] Making Offline Purchase For (Xpay) Gateway Disable & Account Blocked Channel Is Barcode
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-228] Making Offline Purchase For (Xpay) Gateway Disable & Account Expired Channel Is Barcode
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-229] Making Offline Purchase For (Xpay) Gateway Disable & Zero Balance Channel Is Barcode
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-230] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable Channel Is Barcode
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-231] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Account Blocked Channel Is Barcode
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-232] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Account Expired Channel Is Barcode
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-233] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Zero Balance Channel Is Barcode
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-234] Making Offline Purchase For (1pay) Gateway Disable Before Verify Channel Is Barcode
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-235] Making Offline Purchase For (1pay) Gateway Disable & Account Blocked Befor Verify Channel Is Barcode
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-236] Making Offline Purchase For (1pay) Gateway Disable & Account Expired Before Verify Channel Is Barcode
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-237] Making Offline Purchase For (1pay) Gateway Disable & Zero Balance Before Verify Channel Is Barcode
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-238] Making Offline Purchase For (Xpay) Gateway Disable Before Verify Channel Is Barcode
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-239] Making Offline Purchase For (Xpay) Gateway Disable & Account Blocked Before Verify Channel Is Barcode
    Given Allocate No Fee BNPL Account(Xpay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-240] Making Offline Purchase For (Xpay) Gateway Disable & Account Expired Before Verify Channel Is Barcode
    Given Allocate No Fee BNPL Account(Xpay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-241] Making Offline Purchase For (Xpay) Gateway Disable & Zero Balance Before Verify Channel Is Barcode
    Given Allocate No Fee BNPL Account(Xpay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-242] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable Before Verify Channel Is Barcode
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-243] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Account Blocked Before Verify Channel Is Barcode
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-244] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Account Expired Before Verify Channel Is Barcode
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-245] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Zero Balance Before Verify Channel Is Barcode
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-246] Making Offline Purchase For (Credit) Active Account Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase
    ...    ${user_id}
    ...    ${credit_ids}[0]
    ...    amount=${DEFAULT_ALLOCATION_AMOUNT}
    ...    terminal_id=123456789
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then Get Confirmed Status From Credit Management DB And Report Management DB And Purchase Has Terminal Id And RRN
    ...    tracking_code=${tracking_code}
    And The Gateway Is Disabled

[TC-247] Making Offline Purchase For (Credit) Blocked Account Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-248] Making Offline Purchase For (Credit) Expired Account Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-249] Making Offline Purchase For (Credit) With Zero Balance Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-250] Making Offline Purchase For (Credit-With Prepayment) Active Account Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-251] Making Offline Purchase For (Credit-Prepayment) Blocked Account Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-252] Making Offline Purchase For (Credit-Prepayment) Expired Account Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-253] Making Offline Purchase For (Credit-Prepayment) With Zero Balance Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-254] Making Offline Purchase For (Credit) With Fee Active Account Channel Is Barcode
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-255] Making Offline Purchase For (Credit) With Fee Blocked Account Channel Is Barcode
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-256] Making Offline Purchase For (Credit) With Fee Expired Account Channel Is Barcode
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-257] Making Offline Purchase For (Credit-Fee On Purchase) With Zero Balance Channel Is Barcode
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-258] Making Offline Purchase For (Credit) Gateway Disable & Account Blocked Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-259] Making Offline Purchase For (Credit) Gateway Disable & Account Expired Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired

[TC-260] Making Offline Purchase For (Credit) Gateway Disable & Zero Balance Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-261] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-262] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Account Blocked Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-263] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Account Expired Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-264] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Zero Balance Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-265] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable Channel Is Barcode
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-266] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Account Blocked Channel Is Barcode
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-267] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Account Expired Channel Is Barcode
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-268] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Zero Balance Channel Is Barcode
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-269] Making Offline Purchase For (Credit) Gateway Disable Before Verify Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-270] Making Offline Purchase For (Credit) Gateway Disable & Account Blocked Before Verify Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-271] Making Offline Purchase For (Credit) Gateway Disable & Account Expired Before Verify Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    when Expire Account
    and The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-272] Making Offline Purchase For (Credit) Gateway Disable & Zero Balance Before Verify Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-273] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable Before Verify Channel Is Barcode
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-274] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Account Blocked Before Verify Channel Is Barcode
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-275] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Account Expired Before Verify Channel Is Barcode
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-276] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Zero Balance Before Verify Channel Is Barcode
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-277] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable Before Verify Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-278] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Account Blocked Before Verify Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-279] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Account Expired Before Verify Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-280] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Zero Balance Before Verify Channel Is Barcode
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-281] Making Offline Purchase For (Installment Sale) Active Account Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-282] Making Offline Purchase For (Installment Sale) Blocked Account Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-283] Making Offline Purchase For (Installment Sale) Expired Account Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-284] Making Offline Purchase For (Installment Sale) With Zero Balance Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-285] Making Offline Purchase For (Installment Sale-With Prepayment) Active Account Channel Is Barcode
    [Tags]    robot:skip
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-286] Making Offline Purchase For (Installment Sale-Prepayment) Blocked Account Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-287] Making Offline Purchase For (Installment Sale-Prepayment) Expired Account Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-288] Making Offline Purchase For (Installment Sale-Prepayment) With Zero Balance Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-289] Making Offline Purchase For (Installment Sale) With Fee Active Account Channel Is Barcode
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-290] Making Offline Purchase For (Installment Sale) With Fee Blocked Account Channel Is Barcode
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-291] Making Offline Purchase For (Installment Sale) With Fee Expired Account Channel Is Barcode
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Empty Balance
    And Expire Account
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-292] Making Offline Purchase For (Installment Sale-Fee On Purchase) With Zero Balance Channel Is Barcode
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-293] Making Offline Purchase For (Installment Sale) Gateway Disable & Account Blocked Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-294] Making Offline Purchase For (Installment Sale) Gateway Disable & Account Expired Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired

[TC-295] Making Offline Purchase For (Installment Sale) Gateway Disable & Zero Balance Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-296] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-297] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Account Blocked Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-298] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Account Expired Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-299] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Zero Balance Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-300] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable Channel Is Barcode
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-301] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Account Blocked Channel Is Barcode
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-302] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Account Expired Channel Is Barcode
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Empty Balance
    And Expire Account
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-303] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Zero Balance Channel Is Barcode
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-304] Making Offline Purchase For (Installment Sale) Gateway Disable Before Verify Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-305] Making Offline Purchase For (Installment Sale) Gateway Disable & Account Blocked Before Verify Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-306] Making Offline Purchase For (Installment Sale) Gateway Disable & Account Expired Before Verify Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-307] Making Offline Purchase For (Installment Sale) Gateway Disable & Zero Balance Before Verify Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-308] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable Before Verify Channel Is Barcode
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist

[TC-309] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Account Blocked Before Verify Channel Is Barcode
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist

[TC-310] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Account Expired Before Verify Channel Is Barcode
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist

[TC-311] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Zero Balance Before Verify Channel Is Barcode
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-312] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable Before Verify Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And The Gateway Is Disabled
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then Get Confirmed Status From Credit Management DB    tracking_code=${tracking_code}

[TC-313] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Account Blocked Before Verify Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And The Gateway Is Disabled
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then Get Confirmed Status From Credit Management DB    tracking_code=${tracking_code}

[TC-314] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Account Expired Before Verify Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And The Gateway Is Disabled
    And Expire Account
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then Get Confirmed Status From Credit Management DB    tracking_code=${tracking_code}

[TC-315] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Zero Balance Before Verify Channel Is Barcode
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Gateway Is Disabled
    And The Purchase Was Not Exist

[TC-316] Check The purchase Has Uplift(Xpay) Channel Is Linux POS
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    Then Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]    amount=7000
    And The Gateway Is Disabled
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    When Get Confirmed Status From Credit Management DB    tracking_code=${tracking_code}

[TC-317] Check The purchase Has Uplift(1pay) Channel Is Linux POS
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]    amount=7000
    And The Gateway Is Disabled
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then Get Confirmed Status From Credit Management DB    tracking_code=${tracking_code}

[TC-318] Check The purchase Has Uplift(Credit) Channel Is Linux POS
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]    amount=7000
    And The Gateway Is Disabled
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then Get Confirmed Status From Credit Management DB    tracking_code=${tracking_code}

[TC-319] Check The Channel Is Linux Pos On DB
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]    amount=7000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then Check The Linux Pos Channel On Mongo DB
    And The Gateway Is Disabled

[TC-320] Check The Channel Is Barcode On DB
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]    amount=7000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-321] Check The Channel Is Smart POS On DB
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]    amount=7000
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then Check The Smart Pos Channel On Mongo DB
    And The Gateway Is Disabled

[TC-322] Check The Status On DB(1pay)
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    Then Check The Status On Mongo DB    tracking_code=${tracking_code}    cash_amount=${cash_amount}
    And The Gateway Is Disabled

[TC-323] Check The Status On DB(Xpay)
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    then Check The Status On Mongo DB    tracking_code=${tracking_code}    cash_amount=${cash_amount}
    And The Gateway Is Disabled

[TC-324] Check The Status On DB(Credit)
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    Then Check The Status On Mongo DB    tracking_code=${tracking_code}    cash_amount=${cash_amount}
    And The Gateway Is Disabled

[TC-325] Check The Status On DB(Installment Sale)
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then Check The Status On Mongo DB    tracking_code=${tracking_code}    cash_amount=${cash_amount}
    And The Gateway Is Disabled

[TC-326] Check The Gateway On DB(Xpay)
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    Then Complete A Purchase    ${user_id}    ${credit_ids}[0]
    And The Gateway Is Disabled
    Then Check The BPG Gateway On Mongo DB
    And The Gateway Is Disabled

[TC-327] Check The Gateway On DB(Credit)
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    Then Complete A Purchase    ${user_id}    ${credit_ids}[0]
    And The Gateway Is Disabled
    Then Check The CPG Gateway On Mongo DB
    And The Gateway Is Disabled

[TC-328] Check The Gateway On DB(Installment Sale)
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then Check The ISPG Gateway On Mongo DB
    And The Gateway Is Disabled

[TC-329] Check The Fee Charge on DB(1pay)
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    Then Check The Fee Charge On Mongo DB    tracking_code=${tracking_code}    cash_amount=${cash_amount}
    And The Gateway Is Disabled

[TC-330] Check The Fee Charge on DB(Xpay)
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    Then Check The Fee Charge On Mongo DB    tracking_code=${tracking_code}    cash_amount=${cash_amount}
    And The Gateway Is Disabled

[TC-331] Check The Fee Charge on DB(Credit)
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    Then Check The Fee Charge On Mongo DB    tracking_code=${tracking_code}    cash_amount=${cash_amount}
    And The Gateway Is Disabled

[TC-332] Check The Prepayment On DB(Xpay)
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    Then Check The Prepayment On Mongo DB    tracking_code=${tracking_code}    cash_amount=${cash_amount}
    And The Gateway Is Disabled

[TC-333] Check The Prepayment On DB(Credit)
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    Then Check The Prepayment On Mongo DB    tracking_code=${tracking_code}    cash_amount=${cash_amount}
    And The Gateway Is Disabled

[TC-334] Chech The Success Prepayment On Report managment DB(Credit)
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Complete A Purchase    ${user_id}    ${credit_ids}[0]
    Then Send Success Prepayment Event On Report Managmant    tracking_code=${tracking_code}
    And The Gateway Is Disabled

[TC-335] Chech The Success Prepayment On Report managment DB(Xpay)
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Complete A Purchase    ${user_id}    ${credit_ids}[0]
    Then Send Success Prepayment Event On Report Managmant    tracking_code=${tracking_code}
    And The Gateway Is Disabled

[TC-336] Call The Prepayment Before Pay
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    then Call Cash Result Before Pay    tracking_code=${tracking_code}    cash_amount=${cash_amount}
    And The Gateway Is Disabled

[TC-337] Call The Verify Before Pay
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    then Call The Verify Before Pay
    ...    tracking_code=${tracking_code}
    ...    cash_amount=${cash_amount}
    ...    provider_id=${provider_id}
    And The Gateway Is Disabled

[TC-338] Call The Verify Before Pay Cash Result
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    then Call The Verify Before Pay Cash Result
    ...    tracking_code=${tracking_code}
    ...    cash_amount=${cash_amount}
    ...    provider_id=${provider_id}
    And The Gateway Is Disabled

[TC-339] Check The Idemptent For Pay Api(Paid Status)
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    Then Call The Pay Api In Paid Status Two Times    tracking_code=${tracking_code}    cash_amount=${cash_amount}
    And The Gateway Is Disabled

[TC-340] Check The Idempotent For Pay Api(Pending Status)
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    Then Call The Pay Api In Pending Status Two Times    tracking_code=${tracking_code}    cash_amount=${cash_amount}
    And The Gateway Is Disabled

[TC-341] Check The Idempotent For Pay Api(Completed Status)
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then Call The Pay Api In CONFIRMED Status Two Times    tracking_code=${tracking_code}    cash_amount=0
    And The Gateway Is Disabled

[TC-342] Check The Idempotent For Init Api
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    then Call The Init Api in Initiated Status    ${tracking_code}
    And The Gateway Is Disabled

[TC-343] Check Reverse Api In Initated Status
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    Then Call Reverse In Different Status    tracking_code=${tracking_code}    provider_id=${provider_id}
    And The Gateway Is Disabled

[TC-344] Check Reverse Api In Paid Status
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Barcode
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    And Pay The Credit Amount Of The Purchase    tracking_code=${tracking_code}    provider_id=${provider_id}
    Then Call Reverse In Different Status    tracking_code=${tracking_code}    provider_id=${provider_id}
    And The Gateway Is Disabled

[TC-345] Check Reverse Api In Pending Status
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    And Pay The Credit Amount Of The Purchase    tracking_code=${tracking_code}    provider_id=${provider_id}
    Then Call Reverse In Different Status    tracking_code=${tracking_code}    provider_id=${provider_id}
    And The Gateway Is Disabled

[TC-346] Check Reverse Api after pay cash result
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    And Pay The Credit Amount Of The Purchase    tracking_code=${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    tracking_code=${tracking_code}
    Then Call Reverse In Different Status    tracking_code=${tracking_code}    provider_id=${provider_id}
    And The Gateway Is Disabled

[TC-347] Check Reverse Api In Confirmed Status
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    And Pay The Credit Amount Of The Purchase    tracking_code=${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    tracking_code=${tracking_code}
    And Verify Purchase    tracking_code=${tracking_code}    provider_id=${provider_id}
    Then Call Reverse In Different Status    tracking_code=${tracking_code}    provider_id=${provider_id}
    And The Gateway Is Disabled

[TC-348] Check Verify After Reverse
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Smart POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    And Pay The Credit Amount Of The Purchase    tracking_code=${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    tracking_code=${tracking_code}
    Then Call Reverse In Different Status    tracking_code=${tracking_code}    provider_id=${provider_id}
    And The Gateway Is Disabled
    And Verify Purchase After Reverse    tracking_code=${tracking_code}    provider_id=${provider_id}

[TC-349] Check The Idempotent For Reverse Api
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    And Pay The Credit Amount Of The Purchase    tracking_code=${tracking_code}    provider_id=${provider_id}
    And Call Reverse In Different Status    tracking_code=${tracking_code}    provider_id=${provider_id}
    Then Idempotency Of Reverse Api    tracking_code=${tracking_code}    provider_id=${provider_id}
    And The Gateway Is Disabled

[TC-350] Check Pay Cash Result After Reverse
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    when Initiate Purchase    user_id=${user_id}    credit_id=${credit_ids}[0]
    And Pay The Credit Amount Of The Purchase    tracking_code=${tracking_code}    provider_id=${provider_id}
    Then Call Reverse In Different Status    tracking_code=${tracking_code}    provider_id=${provider_id}
    And The Gateway Is Disabled
    And Call Pay Cash Result After Reverse    tracking_code=${tracking_code}

[TC-351] Making Offline Purchase For (1pay) Active Account Channel Is API
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Exist
    And The Gateway Is Disabled

[TC-352] Making Offline Purchase For (1pay) Blocked Account Channel Is API
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-353] Making Offline Purchase For (1pay) Expired Account Channel Is API
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Expire Account    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-354] Making Offline Purchase For (1pay) With Zero Balance Channel Is API
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-355] Making Offline Purchase For (Xpay) Active Account Channel Is API
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    When The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-356] Making Offline Purchase For (Xpay) Blocked Account Channel Is API
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-357] Making Offline Purchase For (Xpay) Expired Account Channel Is API
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    When Expire Account    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-358] Making Offline Purchase For (Xpay) With Zero Balance Channel Is API
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-359] Making Offline Purchase For (Xpay) With Fee Active Account Channel Is API
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-360] Making Offline Purchase For (Xpay) With Fee Blocked Account Channel Is API
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-361] Making Offline Purchase For (Xpay) With Fee Expired Account Channel Is API
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    When Expire Account    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-362] Making Offline Purchase For (Xpay-Fee On Purchase) With Zero Balance Channel Is API
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-363] Making Offline Purchase For (1pay) Gateway Disable Channel Is API
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-364] Making Offline Purchase For (1pay) Gateway Disable & Account Blocked Channel Is API
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-365] Making Offline Purchase For (1pay) Gateway Disable & Account Expired Channel Is API
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Expire Account    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired

[TC-366] Making Offline Purchase For (1pay) Gateway Disable & Zero Balance Channel Is API
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-367] Making Offline Purchase For (Xpay) Gateway Disable Channel Is API
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-368] Making Offline Purchase For (Xpay) Gateway Disable & Account Blocked Channel Is API
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-369] Making Offline Purchase For (Xpay) Gateway Disable & Account Expired Channel Is API
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Expire Account    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-370] Making Offline Purchase For (Xpay) Gateway Disable & Zero Balance Channel Is API
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-371] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable Channel Is API
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-372] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Account Blocked Channel Is API
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-373] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Account Expired Channel Is API
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Expire Account    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-374] Making Offline Purchase For (Xpay-Fee On Purchase) Gateway Disable & Zero Balance Channel Is API
    Given Allocate Fee On Purchase XPay BNPL Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-375] Making Offline Purchase For (1pay) Gateway Disable Befor Verify Channel Is API
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-376] Making Offline Purchase For (1pay) Gateway Disable & Account Blocked Befor Verify Channel Is API
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-377] Making Offline Purchase For (1pay) Gateway Disable & Account Expired Befor Verify Channel Is API
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-378] Making Offline Purchase For (1pay) Gateway Disable & Zero Balance Befor Verify Channel Is API
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-379] Making Offline Purchase For (Credit) Active Account Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-380] Making Offline Purchase For (Credit) Blocked Account Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-381] Making Offline Purchase For (Credit) Expired Account Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Expire Account    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-382] Making Offline Purchase For (Credit) With Zero Balance Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-383] Making Offline Purchase For (Credit-With Prepayment) Active Account Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-384] Making Offline Purchase For (Credit-Prepayment) Blocked Account Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-385] Making Offline Purchase For (Credit-Prepayment) Expired Account Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Expire Account    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-386] Making Offline Purchase For (Credit-Prepayment) With Zero Balance Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-387] Making Offline Purchase For (Credit) With Fee Active Account Channel Is API
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-388] Making Offline Purchase For (Credit) With Fee Blocked Account Channel Is API
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-389] Making Offline Purchase For (Credit) With Fee Expired Account Channel Is API
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Expire Account    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-390] Making Offline Purchase For (Credit-Fee On Purchase) With Zero Balance Channel Is API
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-391] Making Offline Purchase For (Credit) Gateway Disable & Active Account Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-392] Making Offline Purchase For (Credit) Gateway Disable & Account Blocked Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-393] Making Offline Purchase For (Credit) Gateway Disable & Account Expired Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Expire Account    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired

[TC-394] Making Offline Purchase For (Credit) Gateway Disable & Zero Balance Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-395] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Active Account Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-396] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Account Blocked Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-397] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Account Expired Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Expire Account    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-398] Making Offline Purchase For (Credit-With Prepayment) Gateway Disable & Zero Balance Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-399] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable Channel Is API
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-400] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Account Blocked Channel Is API
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-401] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Account Expired Channel Is API
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Expire Account    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-402] Making Offline Purchase For (Credit-Fee On Purchase) Gateway Disable & Zero Balance Channel Is API
    Given Allocate Fee On Purchase CCREDIT Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-403] Making Offline Purchase For (Credit) Gateway Disable & Active Account Befor Verify Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-404] Making Offline Purchase For (Credit) Gateway Disable & Account Blocked Befor Verify Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Account Blocked
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API And Account Is Block

[TC-405] Making Offline Purchase For (Credit) Gateway Disable & Account Expired Befor Verify Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Expire Account
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-406] Making Offline Purchase For (Credit) Gateway Disable & Zero Balance Befor Verify Channel Is API
    Given Allocate No Fee CCredit Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To CPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    When The Gateway Is Disabled
    Then The Purchase Was Not Exist

[TC-407] Making Offline Purchase For (Installment Sale) Active Account Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    And Verify Purchase    ${tracking_code}    ${provider_id}
    Then The Purchase Exist
    And The Gateway Is Disabled

[TC-408] Making Offline Purchase For (Installment Sale) Blocked Account Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-409] Making Offline Purchase For (Installment Sale) Expired Account Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Expire Account    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-410] Making Offline Purchase For (Installment Sale) With Zero Balance Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-411] Making Offline Purchase For (Installment Sale-With Prepayment) Active Account Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-412] Making Offline Purchase For (Installment Sale-Prepayment) Blocked Account Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-413] Making Offline Purchase For (Installment Sale-Prepayment) Expired Account Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Expire Account    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-414] Making Offline Purchase For (Installment Sale-Prepayment) With Zero Balance Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-415] Making Offline Purchase For (Installment Sale) With Fee Active Account Channel Is API
    [Tags]    robot:skip
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When Verify Purchase    ${tracking_code}    provider_id=${provider_id}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-416] Making Offline Purchase For (Installment Sale) With Fee Blocked Account Channel Is API
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Account Blocked
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-417] Making Offline Purchase For (Installment Sale) With Fee Expired Account Channel Is API
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Expire Account    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired
    And The Gateway Is Disabled

[TC-418] Making Offline Purchase For (Installment Sale-Fee On Purchase) With Zero Balance Channel Is API
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    when Empty Balance    credit_id=${credit_ids}[0]
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-419] Making Offline Purchase For (Installment Sale) Gateway Disable & Active Account Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-420] Making Offline Purchase For (Installment Sale) Gateway Disable & Account Blocked Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-421] Making Offline Purchase For (Installment Sale) Gateway Disable & Account Expired Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Expire Account    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Account Expired

[TC-422] Making Offline Purchase For (Installment Sale) Gateway Disable & Zero Balance Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-423] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-424] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Account Blocked Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-425] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Account Expired Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Expire Account    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-426] Making Offline Purchase For (Installment Sale-With Prepayment) Gateway Disable & Zero Balance Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-427] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable Channel Is API
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-428] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Account Blocked Channel Is API
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Account Blocked
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-429] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Account Expired Channel Is API
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Expire Account    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Account Expired

[TC-430] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable & Zero Balance Channel Is API
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Greater Than Credit Balance
    And Empty Balance    credit_id=${credit_ids}[0]
    When The Gateway Is Disabled
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Did Not Exist Because The Gateway disable

[TC-431] Making Offline Purchase For (Installment Sale) Gateway Disable Befor Verify Channel Is API
    Given Allocate No Fee Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Exist

[TC-432] Making Offline Purchase For (Installment Sale-Fee On Purchase) Gateway Disable Befor Verify Channel Is API
    [Tags]    robot:skip
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${DEFAULT_ALLOCATION_AMOUNT}
    And Pay The Credit Amount Of The Purchase    ${tracking_code}    provider_id=${provider_id}
    And Pay The Cash Amount Of The Purchase    ${tracking_code}
    When The Gateway Is Disabled
    Then Verify Purchase    ${tracking_code}    ${provider_id}
    and The Purchase Did Not Exist Because The Gateway disable After Call Verify API

[TC-433] Init Purchase With All Valid Data
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Offline Purchase Init Is Requested With All Valid Data
    Then Purchase Init Response Status Should Be    200
    And The Gateway Is Disabled

[TC-434] Init Purchase With Wrong CreditId Type
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Offline Purchase Init Is Requested With Wrong CreditId Type
    Then Purchase Init Response Status Should Be    422
    And The Gateway Is Disabled

[TC-435] Init Purchase With Null UserId And Null CellNumber On API Channel
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To API
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Offline Purchase Init Is Requested With Null UserId And Null CellNumber
    Then Purchase Init Response Status Should Be    422
    And The Gateway Is Disabled

[TC-436] Init Purchase With Missing basket Detail
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Offline Purchase Init Is Requested With Missing basket Detail
    Then Purchase Init Response Status Should Be    200
    And The Gateway Is Disabled

[TC-437] Init Purchase With No Headers
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Offline Purchase Init Is Requested With No Version In Headers
    Then Purchase Init Response Status Should Be    200
    And The Gateway Is Disabled

[TC-438] Init Purchase With Wrong Product Type
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Offline Purchase Init Is Requested With Wrong Product Type
    Then Purchase Init Response Status Should Be    400
    And The Gateway Is Disabled

[TC-439] Init Purchase With Empty Body
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Offline Purchase Init Is Requested With Empty Body
    Then Purchase Init Response Status Should Be    400
    And The Gateway Is Disabled

[TC-440] Pay Cash Result Should Not Be Allowed (cashAmount == 0)
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Purchase Is Initialized Successfully With Cash Amount Equal To Zero
    And Purchase Pay Step Was Completed Successfully
    When Offline Purchase Cash Pay Result Is Requested With All Valid Data
    Then Cash Pay Result Response Status Should Be    422
    And The Gateway Is Disabled

[TC-441] Pay With All Valid Data
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Purchase Is Initialized Successfully With Cash Amount Greater Than Zero
    When Offline Purchase Pay Is Requested With All Valid Data
    Then Purchase Pay Response Status Should Be    200
    And The Gateway Is Disabled

[TC-442] Pay With Invalid TrackingCode
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Purchase Is Initialized Successfully With Cash Amount Greater Than Zero
    When Offline Purchase Pay Is Requested With Invalid TrackingCode
    Then Purchase Pay Response Status Should Be    422
    And The Gateway Is Disabled

[TC-443] Pay With Null TrackingCode
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Purchase Is Initialized Successfully With Cash Amount Greater Than Zero
    When Offline Purchase Pay Is Requested With Null Tracking Code
    Then Purchase Pay Response Status Should Be    422
    And The Gateway Is Disabled

[TC-444] Pay With Missing TrackingCode
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Purchase Is Initialized Successfully With Cash Amount Greater Than Zero
    When Offline Purchase Pay Is Requested With Missing TrackingCode
    Then Purchase Pay Response Status Should Be    422
    And The Gateway Is Disabled

[TC-445] Pay With Empty Body
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Purchase Is Initialized Successfully With Cash Amount Greater Than Zero
    When Offline Purchase Pay Is Requested With Empty Body
    Then Purchase Pay Response Status Should Be    422
    And The Gateway Is Disabled

[TC-446] Pay Cash Result With All Valid Data (cashAmount > 0)
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To Linux POS
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And Purchase Is Initialized Successfully With Cash Amount Greater Than Zero
    And Purchase Pay Step Was Completed Successfully
    When Offline Purchase Cash Pay Result Is Requested With All Valid Data
    Then Cash Pay Result Response Status Should Be    200
    And The Gateway Is Disabled

[TC-416] Making Offline Purchase For (Installment Sale) With Fee Schedule Close Account Channel Is API
    Given Allocate Fee On Purchase Installment Sale Account
    And The Channel Is Set To API
    And The Payment Gateway Is Set To ISPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When Call Schedule Close API
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=11000
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled

[TC-417] Making Offline Purchase For (1pay) And Channel Is PLATFORM CARD
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To PLATFORM CARD
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    when Complete A Purchase    ${user_id}    ${credit_ids}[0]    terminal_id=123456789
    Then Get Confirmed Status From Credit Management DB And Report Management DB And Purchase Has Terminal Id And RRN
    ...    tracking_code=${tracking_code}
    And The Gateway Is Disabled

[TC-418] Making Offline Purchase For (Xpay) And Channel Is PLATFORM CARD
    Given Allocate No Fee BNPL Account(xpay)
    And The Channel Is Set To PLATFORM CARD
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    And The Amount Is Set To Equal To Credit Balance
    when Complete A Purchase    ${user_id}    ${credit_ids}[0]    terminal_id=123456789
    Then Get Confirmed Status From Credit Management DB And Report Management DB And Purchase Has Terminal Id And RRN
    ...    tracking_code=${tracking_code}
    And The Gateway Is Disabled

[TC-419] Making Offline Purchase For (Xpay) And Amount Is Set To Greater Than Credit Balance And Channel Is PLATFORM CARD
    Given Allocate No Fee BNPL Account(1pay)
    And The Channel Is Set To PLATFORM CARD
    And The Payment Gateway Is Set To BPG
    And The Gateway RepaymentOption Is Set To 1pay And Xpay
    When The Amount Is Set To Greater Than Credit Balance
    And Initiate Purchase    ${user_id}    ${credit_ids}[0]    amount=${AMOUNT}
    Then The Purchase Was Not Exist
    And The Gateway Is Disabled