*** Settings ***
Resource            steps/LMS/credit-core/close-eligibility-step.resource

Test Teardown       Reproduce Amount


*** Test Cases ***
[TC-001] BNPL With No Purchase Close Eligibility Test
    Given Credit Allocation    types=${{['${LMS_Account_Type_1PAY}']}}
    Then Account Should Be Eligible To Close    creditId=${credit_ids}[0]

[TC-002] CREDIT With No Purchase Close Eligibility Test
    Given Credit Allocation    types=${{['${LMS_Account_Type_CREDIT}']}}
    Then Account Should Not Be Eligible To Close    creditId=${credit_ids}[0]

[TC-003] Company Credit With No Purchase Close Eligibility Test
    Given Credit Allocation    types=${{['${LMS_Account_Type_CREDIT}']}}    fund_providers=${{['${LMS_FP_COMPANY}']}}
    Then Account Should Be Eligible To Close    creditId=${credit_ids}[0]

[TC-004] INSTALLMENT SALE With No Purchase Close Eligibility Test
    Given Credit Allocation    types=${{['${LMS_Account_Type_INSTALLMENT_SALE}']}}
    Then Account Should Not Be Eligible To Close    creditId=${credit_ids}[0]
