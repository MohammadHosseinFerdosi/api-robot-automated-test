# Payment Channel Status Testing Documentation

## Overview

This document describes the comprehensive test cases for testing payment channel status scenarios in the LMS inquiry API. The tests cover different payment channel values and their corresponding status responses, with special focus on installment sale validation, API channel full credit purchases, and repayment option mismatches.

## Test Scenarios

### Payment Channel = 0 Scenarios (API Channel)

When `paymentChannel` is equal to 0 (API channel), the status can be:

-   **UNUSABLE(0)** - when account is blocked or expired
-   **SUFFICIENT(1)** - when amount = remainBalance (full credit purchase only)
-   **INSUFFICIENT(2)** - when amount > remainBalance

**Important**: For API channel, only full credit purchases (amount = remainBalance) are valid. Partial purchases return INSUFFICIENT status.

### Payment Channel ≠ 0 Scenarios

When `paymentChannel` is not equal to 0, the status can be:

-   **ACTIVE(0)** - account is active and usable
-   **CLOSE(1)** - account is closed
-   **INACTIVE(2)** - account is inactive
-   **BLOCK(3)** - account is blocked

### Installment Sale Validation

For INSTALLMENT_SALE accounts:

-   **API Channel**: Only amount >= remainBalance is valid (full credit purchase)
-   **Non-API Channels**: Only amount = remainBalance is valid (exact balance required)
-   **Partial purchases**: Return empty inquiry list for both API and non-API channels

### Repayment Option Mismatches

When account type and repayment option don't match:

-   **1PAY account with XPAY repayment option**: Returns empty inquiry list
-   **XPAY account with 1PAY repayment option**: Returns empty inquiry list
-   **CREDIT account with 1PAY repayment option**: Returns empty inquiry list
-   **INSTALLMENT_SALE account with 1PAY repayment option**: Returns empty inquiry list

### Fee-Based Account Behavior

For accounts with **fee on purchase**:

-   **Fee is paid in cash** - it doesn't affect the credit balance
-   **Credit balance** is only used for the actual purchase amount
-   **Amount validation** only checks: `amount <= credit_balance`
-   **Fee amount** is separate and paid in cash by the user

**Example:**

-   Purchase amount: 5000 (from credit balance)
-   Fee on purchase: 500 (paid in cash)
-   Total transaction: 5500 (5000 credit + 500 cash)
-   Validation: 5000 <= credit_balance (fee doesn't factor in)

### API Channel with Fee on Purchase

**Important**: API channel (payment channel = 0) **does not support cash payments**.

For fee-based accounts in API channel:

-   **Full credit purchase** (amount = balance) → Status 1 (SUFFICIENT)
-   **Partial purchase** (amount < balance) → Status 2 (INSUFFICIENT)
-   Reason: API channel doesn't allow cash payments for fees
-   User would need to pay fee in cash, but API channel is credit-only
-   **INSTALLMENT_SALE accounts** with partial purchase → Empty list (strict validation)

**Non-API channels** allow fee-based accounts with partial purchases because they support cash payments for fees.

### Important Notes

-   `remainBalance` should be `null` in all test cases in inquiry response
-   Each test case includes proper payment gateway setup and teardown
-   Tests cover all account types: 1PAY, XPAY, CREDIT, INSTALLMENT_SALE
-   **Repayment options must be set** based on account type for tests to work properly
-   **API channel only supports full credit purchases** (amount = remainBalance)
-   **Installment sale accounts have strict amount validation**
-   **Fee on purchase is a cash amount that doesn't affect credit balance validation**

## Test Categories

### 1. Payment Channel = 0 Tests (TC-001 to TC-010)

These tests verify the behavior when payment channel is set to 0 (API channel):

-   **TC-001**: Blocked account → Status should be 0 (UNUSABLE)
-   **TC-002**: Expired account → Status should be 0 (UNUSABLE)
-   **TC-003**: Sufficient balance (amount = balance) → Status should be 1 (SUFFICIENT)
-   **TC-004**: Insufficient balance (amount > balance) → Status should be 2 (INSUFFICIENT)
-   **TC-005**: Zero balance → Status should be 2 (INSUFFICIENT)
-   **TC-006**: XPAY account with sufficient balance → Status should be 1 (SUFFICIENT)
-   **TC-007**: CREDIT account with sufficient balance → Status should be 1 (SUFFICIENT)
-   **TC-008**: INSTALLMENT_SALE account with sufficient balance → Status should be 1 (SUFFICIENT)
-   **TC-009**: INSTALLMENT_SALE account with insufficient balance → Should return empty list
-   **TC-010**: INSTALLMENT_SALE account with partial balance → Should return empty list

### 2. Payment Channel ≠ 0 Tests (TC-011 to TC-017)

These tests verify the behavior when payment channel is not 0:

-   **TC-011**: Active account → Status should be 0 (ACTIVE)
-   **TC-012**: Closed account → Status should be 1 (CLOSE)
-   **TC-013**: Inactive account → Status should be 2 (INACTIVE)
-   **TC-014**: Blocked account → Status should be 3 (BLOCK)
-   **TC-015**: XPAY account active → Status should be 0 (ACTIVE)
-   **TC-016**: CREDIT account active → Status should be 0 (ACTIVE)
-   **TC-017**: INSTALLMENT_SALE account active → Status should be 0 (ACTIVE)

### 3. Repayment Option Mismatch Tests (TC-018 to TC-025)

These tests verify behavior when account type and repayment option don't match:

-   **TC-018**: 1PAY account with XPAY repayment option (API channel) → Empty list
-   **TC-019**: XPAY account with 1PAY repayment option (API channel) → Empty list
-   **TC-020**: CREDIT account with 1PAY repayment option (API channel) → Empty list
-   **TC-021**: INSTALLMENT_SALE account with 1PAY repayment option (API channel) → Empty list
-   **TC-022**: 1PAY account with XPAY repayment option (non-API channel) → Empty list
-   **TC-023**: XPAY account with 1PAY repayment option (non-API channel) → Empty list
-   **TC-024**: CREDIT account with 1PAY repayment option (non-API channel) → Empty list
-   **TC-025**: INSTALLMENT_SALE account with 1PAY repayment option (non-API channel) → Empty list

### 4. Installment Sale Amount Validation Tests (TC-026 to TC-029)

These tests verify installment sale amount validation rules:

-   **TC-026**: INSTALLMENT_SALE account with amount = balance (non-API channel) → Status 0 (ACTIVE)
-   **TC-027**: INSTALLMENT_SALE account with amount < balance (non-API channel) → Empty list
-   **TC-028**: INSTALLMENT_SALE account with amount > balance (non-API channel) → Empty list
-   **TC-029**: INSTALLMENT_SALE account with zero balance (non-API channel) → Empty list

### 5. Different Payment Channels Testing (TC-030 to TC-034)

Tests for different payment channel values:

-   **TC-030**: UPG channel
-   **TC-031**: SMART_POS channel
-   **TC-032**: QR channel
-   **TC-033**: BARCODE channel
-   **TC-034**: LINUX_POS channel

### 6. Edge Cases and Boundary Testing (TC-035 to TC-038)

Tests for edge cases:

-   **TC-035**: Exact balance when payment channel is 0
-   **TC-036**: Zero balance and zero amount when payment channel is 0
-   **TC-037**: Zero balance and positive amount when payment channel is 0
-   **TC-038**: Negative balance when payment channel is 0

### 7. Multiple Account Types Testing (TC-039 to TC-041)

Tests with multiple account types:

-   **TC-039**: Multiple account types when payment channel is 0
-   **TC-040**: Multiple account types when payment channel is not 0
-   **TC-041**: Mixed account statuses when payment channel is not 0

### 8. Error Scenarios (TC-042 to TC-044)

Tests for error conditions:

-   **TC-042**: Invalid payment channel value
-   **TC-043**: Missing payment channel parameter
-   **TC-044**: Negative payment channel value

## Test Execution

### Running Specific Test Categories

```bash
# Run all payment channel = 0 tests
robot --include payment_channel_0 features/lms/payment-channel-status-test.robot

# Run all payment channel != 0 tests
robot --include payment_channel_not_0 features/lms/payment-channel-status-test.robot

# Run repayment option mismatch tests
robot --include repayment_mismatch features/lms/payment-channel-status-test.robot

# Run installment sale validation tests
robot --include installment_sale features/lms/payment-channel-status-test.robot

# Run edge case tests
robot --include edge_case features/lms/payment-channel-status-test.robot

# Run error scenario tests
robot --include error_case features/lms/payment-channel-status-test.robot
```

### Running by Severity

```bash
# Run high severity tests
robot --include "severity:high" features/lms/payment-channel-status-test.robot

# Run medium severity tests
robot --include "severity:medium" features/lms/payment-channel-status-test.robot
```

## Test Structure

Each test case follows this structure:

1. **Given** - Setup phase:

    - Allocate appropriate account type
    - Set account status (if needed)
    - Set payment channel
    - **Set repayment option** (based on account type)
    - Set payment gateway
    - Set amount (considering validation rules)
    - Set product type
    - Activate credit gateway

2. **When** - Action phase:

    - Call inquiry API

3. **Then** - Verification phase:
    - Verify inquiry list length
    - Verify status values
    - Verify remain balance is null
    - Disable credit gateway

## Account Type to Repayment Option Mapping

-   **1PAY accounts**: Use `Set Repayment Option 1PAY`
-   **XPAY accounts**: Use `Set Repayment Option XPAY`
-   **CREDIT accounts**: Use `Set Repayment Option XPAY` (CREDIT accounts work with XPAY repayment option)
-   **INSTALLMENT_SALE accounts**: Use `Set Repayment Option XPAY` (INSTALLMENT_SALE accounts work with XPAY repayment option)
-   **Multiple account types**: Use `Set Repayment Option 1PAY And XPAY`

## Payment Gateway Mapping

-   **1PAY/XPAY accounts**: Use BPG (Buy Now Pay Later Gateway)
-   **CREDIT accounts**: Use CPG (Credit Payment Gateway)
-   **INSTALLMENT_SALE accounts**: Use ISPG (Installment Sale Payment Gateway)

## Amount Validation Rules

### API Channel (Payment Channel = 0)

-   **1PAY/XPAY/CREDIT accounts**: Only amount = remainBalance is valid (full credit purchase)
-   **INSTALLMENT_SALE accounts**: Only amount >= remainBalance is valid (full credit purchase)
-   **Partial purchases**: Return INSUFFICIENT(2) status for 1PAY/XPAY/CREDIT, empty list for INSTALLMENT_SALE

### Non-API Channels (Payment Channel ≠ 0)

-   **1PAY/XPAY/CREDIT accounts**: Any amount is valid
-   **INSTALLMENT_SALE accounts**: Only amount = remainBalance is valid (exact balance required)
-   **Partial purchases**: Return empty list for INSTALLMENT_SALE accounts

## Expected Results

### For Payment Channel = 0 (API Channel):

-   Account blocked/expired → Status: 0 (UNUSABLE)
-   Full credit purchase (amount = balance) → Status: 1 (SUFFICIENT)
-   Partial purchase (amount < balance) → Status: 2 (INSUFFICIENT) for 1PAY/XPAY/CREDIT, empty list for INSTALLMENT_SALE
-   Over purchase (amount > balance) → Status: 2 (INSUFFICIENT) for 1PAY/XPAY/CREDIT, empty list for INSTALLMENT_SALE

### For Payment Channel ≠ 0:

-   Active account → Status: 0 (ACTIVE)
-   Closed account → Status: 1 (CLOSE)
-   Inactive account → Status: 2 (INACTIVE)
-   Blocked account → Status: 3 (BLOCK)
-   INSTALLMENT_SALE with amount ≠ balance → Empty list

### For Repayment Option Mismatches:

-   Account type doesn't match repayment option → Empty list

### Common for All Tests:

-   `remainBalance` should be `null`
-   Proper gateway activation/deactivation
-   Correct inquiry list length based on account types and validation rules
-   Repayment options must match account types

## Troubleshooting

### Common Issues

1. **Gateway not activated**: Ensure `Credit Gateway Activate` is called before API call
2. **Wrong payment gateway**: Match gateway type with account type
3. **Missing product type**: Always set product type to CONSUMPTION GOODS
4. **Account not in expected state**: Verify account allocation and status setting
5. **Repayment option not found**: Ensure repayment option is set based on account type
6. **Wrong repayment option**: Match repayment option with account type
7. **Amount validation failure**: Ensure amount follows validation rules for account type and payment channel
8. **Installment sale partial purchase**: Only full credit purchases are allowed for installment sale accounts

### Debug Steps

1. Check if account is properly allocated
2. Verify payment gateway is activated
3. Confirm payment channel is set correctly
4. **Verify repayment option is set correctly for account type**
5. **Validate amount follows rules for account type and payment channel**
6. Validate account status (blocked, expired, etc.)
7. Check API response for expected status values or empty list

## Maintenance

### Adding New Test Cases

When adding new test cases:

1. Follow the existing naming convention: `[TC-XXX][Category] Description`
2. Include appropriate tags for categorization
3. Add proper setup and teardown steps
4. Include payment gateway activation/deactivation
5. **Set appropriate repayment option based on account type**
6. **Follow amount validation rules for account type and payment channel**
7. Verify remain balance is null
8. Test both payment channel = 0 and ≠ 0 scenarios
9. **Test repayment option mismatches**
10. **Test installment sale amount validation**

### Updating Existing Tests

When updating existing tests:

1. Maintain the same structure
2. Update comments if status meanings change
3. Ensure all assertions are still valid
4. Test with different account types if needed
5. **Verify repayment option mapping is correct**
6. **Verify amount validation rules are followed**
7. **Test installment sale specific scenarios**
