# LMS Credit Core Test Handover

This document is a practical handover guide for the LMS credit-core Robot Framework tests. It covers the current feature, step, API, and service layers so the next test engineer can understand where to add tests, where to reuse existing helpers, and which conventions are important to keep.

## Scope

The LMS credit-core automation covers credit account lifecycle, merchant gateway configuration, purchase initiation and completion, purchase inquiry/detail/info, payment method inquiry, refunds, residue, early settlement, account closing, fund provider/profile creation, coupons, and transaction/activity checks.

Primary folders:

| Layer       | Path                                          | Purpose                                                                                                        |
| ----------- | --------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| Features    | `features/lms/credit-core/`                   | Gherkin-style Robot test scenarios. Each file usually imports one matching step resource.                      |
| Steps       | `src/steps/LMS/credit-core/`                  | Business-readable step keywords, test setup/teardown, assertions, DB checks, and flow orchestration.           |
| APIs        | `src/apis/lms/credit-core/`                   | Low-level HTTP keyword wrappers for credit-core and related LMS APIs.                                          |
| Services    | `src/services/backend/LMS/credit-core/`       | Reusable backend workflows used by LMS and cross-team tests.                                                   |
| Test data   | `src/data/lms/` and `src/data/CONSTANTS.yaml` | LMS constants, channels, gateways, account types, fund providers, fees, test merchants, and purchase defaults. |
| Environment | `src/config/environment-stage.yaml`           | UAT hosts, microservice paths, DB settings, business IDs, and auth settings.                                   |

## How To Run

Run one credit-core suite:

```powershell
robot --variablefile src/config/environment-stage.yaml --pythonpath src features/lms/credit-core/online-purchase.robot
```

Run the full credit-core folder:

```powershell
robot --variablefile src/config/environment-stage.yaml --pythonpath src features/lms/credit-core
```

Run in parallel when the environment and data can handle it:

```powershell
pabot --processes 4 --variablefile src/config/environment-stage.yaml --pythonpath src features/lms/credit-core
```

Large suites such as `offline-purchase.robot`, `pmi-customer.robot`, `inquiry.robot`, `manifest.robot`, and `online-purchase.robot` can be slow and can touch shared gateway or merchant state. Prefer running a single file or a smaller tag/test range while developing.

## Architecture

The usual flow is:

```text
feature.robot
  -> src/steps/LMS/credit-core/*-step.resource
    -> src/apis/lms/credit-core/*.resource
    -> src/services/backend/LMS/credit-core/*.resource
    -> shared services in src/services/backend/ and src/services/db/
```

Keep feature files readable and business-oriented. Put reusable setup, orchestration, assertions, DB validation, and retry logic in step or service resources. Put only request construction and response normalization in API resources.

## Feature Inventory

| Feature file                        | Step resource                              | Test cases | Main coverage                                                                                                    |
| ----------------------------------- | ------------------------------------------ | ---------: | ---------------------------------------------------------------------------------------------------------------- |
| `account-info.robot`                | `account-info.resource`                    |         22 | Gateway account info by user/account type, billing cycle assignment, blocked/active state.                       |
| `account-summary.robot`             | `account-creditId-summary.resource`        |          8 | Account summary by credit ID, blocking details, remaining balance.                                               |
| `block-account.robot`               | `credit-account-block-step.resource`       |          4 | Manual block for BNPL, credit, installment sale, XPAY.                                                           |
| `close-eligibility.robot`           | `close-eligibility-step.resource`          |          4 | Close eligibility across 1PAY, credit, Company credit, installment sale.                                        |
| `coupon.robot`                      | `coupon-step.resource`                     |          1 | Campaign, coupon, and coupon-code creation.                                                                      |
| `credit-account-info.robot`         | `accounts-step.resource`                   |          9 | Credit account management account info and schedule-close state.                                                 |
| `credit-features.robot`             | `credit-features-step.resource`            |        180 | Feature API matrix across account types, balances, gateway state, channel, repayment option, and account status. |
| `early-settlements.robot`           | `early-settlements-steps.resource`         |          2 | Early settlement init/detail/pay wallet scenarios.                                                               |
| `fund-provider.robot`               | `fund-provider-step.resource`              |          1 | Fund provider creation and persistence.                                                                          |
| `gateways.robot`                    | `gateways-step.resource`                   |          1 | Gateway activation/inquiry/disable behavior.                                                                     |
| `inquiry.robot`                     | `inquiry-step.resource`                    |        326 | Purchase inquiry matrix for account types, fees, channels, gateways, and user/account states.                    |
| `manifest.robot`                    | `manifest-step.resource`                   |        199 | Gateway manifest responses and available payment methods.                                                        |
| `merchant-contract.robot`           | `merchant-contract-activate-step.resource` |          1 | Merchant contract/gateway activation path.                                                                       |
| `merchant-managment-gateways.robot` | `account-merchant-management.resource`     |         50 | Merchant-management account and gateway views.                                                                   |
| `offline-purchase.robot`            | `offline-purchase-step.resource`           |        450 | Offline purchase lifecycle across channels, repayment options, account/fund/fee states, and negative cases.      |
| `online-purchase.robot`             | `online-purchase-step.resource`            |        257 | Ticket-based online purchase lifecycle, gateway state, blocked/expired accounts, validations, reports.           |
| `payment-channel-status-test.robot` | `inquiry-step.resource`                    |         67 | API vs non-API payment-channel status behavior.                                                                  |
| `pmi-customer.robot`                | `payment-methods-customer-steps.resource`  |        421 | Customer payment method inquiry matrix.                                                                          |
| `profile.robot`                     | `create-profile-step.resource`             |          1 | Profile creation.                                                                                                |
| `purchase-detail.robot`             | `purchase-detail-step.resource`            |         83 | Purchase detail response by account/channel/gateway/fee state.                                                   |
| `purchase-info.robot`               | `purchase-info-step.resource`              |        100 | Purchase info response by account/channel/gateway/fee state.                                                     |
| `purchase-inquiry.robot`            | `purchase-inquiry-steps.resource`          |         15 | Purchase inquiry API basics and gateway availability.                                                            |
| `purchases-init.robot`              | `purchases-init-step.resource`             |         45 | Purchase init validation and setup matrix.                                                                       |
| `refund.robot`                      | `refund-step.resource`                     |         38 | Full/partial refund, settlement method, billing cycle, report, notification checks.                              |
| `residue.robot`                     | `residue-steps.resource`                   |         19 | Expiration residue creation, fee/prepayment calculations, SMS and record checks.                                 |
| `schedule-close.robot`              | `schedule-close-step.resource`             |          4 | Account close scheduling and DB state transitions.                                                               |
| `transactions.robot`                | `transactions-step.resource`               |          8 | Transaction list and receipt behavior.                                                                           |
| `unblock-account.robot`             | `credit-account-unblock-step.resource`     |          3 | Manual unblock for account types.                                                                                |

## Main Step Resources

Use these as the first place to look when changing behavior:

| Step resource                                                                 | Main responsibility                                                                                           |
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `online-purchase-step.resource`                                               | Online purchase setup, account allocation, gateway config, ticket flow assertions, report/DB consistency.     |
| `offline-purchase-step.resource`                                              | Offline purchase setup and complete purchase scenarios across payment channels.                               |
| `inquiry-step.resource`                                                       | Feature/purchase inquiry matrices and gateway enable/disable combinations.                                    |
| `payment-methods-customer-steps.resource`                                     | PMI/customer payment method scenarios.                                                                        |
| `manifest-step.resource`                                                      | Gateway manifest request setup and response validation.                                                       |
| `refund-step.resource`                                                        | Refund flows and consistency checks across credit, merchant, report, billing, and notification records.       |
| `residue-steps.resource`                                                      | Expiration and residue checks across credit account, credit profile, residue, and notification data.          |
| `schedule-close-step.resource`                                                | Manual close/schedule-close support, billing cycle changes, wallet balance alignment, installment DB updates. |
| `credit-account-block-step.resource` / `credit-account-unblock-step.resource` | Account block/unblock calls and account DB validation.                                                        |
| `create-profile-step.resource` / `fund-provider-step.resource`                | Admin creation flows and persistence checks.                                                                  |

Most step resources define `Reproduce Amount` or `Reproduce Amount And Credit Gateway Disable` as teardown. Do not remove these casually; they return test funds and reset merchant gateway state after scenarios.

## Backend Services

The files in `src/services/backend/LMS/credit-core/` are the reusable service layer. Other teams should call these service keywords rather than duplicating database updates or multi-call workflows.

| Service resource                   | Important keywords                                                                                                                                                                                                    | Notes                                                                                                                                      |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| `credit-online-purchase.resource`  | `Perform A Complete Online Credit Purchase`, `Get ticket`, `Purchase credit prepare`, `Purchase route info`, `Purchase credit pay`, `Purchase Verify`, `Purchase Deliver`                                             | Handles ticket-based online purchase from ticket generation through delivery. Also reads `credit_mng_db.purchases` to find tracking codes. |
| `credit-offline-purchase.resource` | `Perform A Complete Offline Purchase`, `Perform A Reversed Offline Purchase`, `Initiate The Offline Purchase`, `Pay The Credit Amount`, `Pay The Cash`, `Verify The Purchase`, `Reverse Purchase`, `Purchase Deliver` | Main service for offline purchase lifecycle and reversals.                                                                                 |
| `close-account.resource`           | `Close Account`, `Close User Accounts`, `Call Close API`, `Check credit account status`, `Update installment contract status`                                                                                         | Cross-team entry point for closing credit accounts. Uses MongoDB and MySQL updates when preparing closeable states.                        |
| `close-billing-cycles.resource`    | `Close billing cycles`, `Check billing cycles status`, `Update unassigned purchases status To Expired`                                                                                                                | Used before closing or scheduling close when billing cycles block state transitions.                                                       |
| `expire-credit-account.resource`   | `Expire credit account`, `Expire Account While Having Purchase Handler`, `Expire Account Default Handler`                                                                                                             | Forces expiration instead of waiting for scheduler behavior.                                                                               |
| `create-profile.resource`          | `Create Profile`, `Check Databases`                                                                                                                                                                                   | Creates profile and validates propagation across profile/account/credit/agreement/residue/revolving stores depending on profile type.      |
| `fund-provider.resource`           | `Create Fund Provider`, `Check Databases`                                                                                                                                                                             | Creates fund provider and validates MongoDB/MySQL propagation.                                                                             |
| `pay-early-settlement.resource`    | `Initiate The Early Settlement`, `Initiate The User Wallet For The Early Settlement`, `Pay Early Settlement Via Wallet`                                                                                               | Charges wallet and pays early-settlement ticket through wallet.                                                                            |

## API Layer

API resources live in `src/apis/lms/credit-core/`. They follow the standard template:

1. Build headers and body/query parameters.
2. Set the base API path.
3. If `${api_call_side}` is `${MICROSERVICE_SIDE}`, prepend the correct microservice path.
4. Create session with `Create A Session`.
5. Call the endpoint with `expected_status=any`.
6. Return a dictionary with `status_code` and `body`.
7. Delete the session in `[Teardown]`.

Common microservice path variables:

| Path variable                     | Used for                                                                                   |
| --------------------------------- | ------------------------------------------------------------------------------------------ |
| `${MS_CREDIT_MNG_PATH}`           | Credit management purchase, inquiry, reverse, early settlement, and coupon-adjacent calls. |
| `${MS_CREDIT_ACCOUNT_MNG_PATH}`   | Credit account management account lookup/close-related calls.                              |
| `${MS_CREDIT_MERCHANT_MNG_PATH}`  | Merchant gateway activation/disable and merchant gateway behavior.                         |
| `${MS_CREDIT_MNG_MERCHANTS_PATH}` | Merchant payment methods/customer endpoint.                                                |
| `${MS_COUPON}`                    | Coupon service APIs where used.                                                            |

When adding a new API, copy the structure from a nearby file and only change the endpoint-specific headers/body/path. The repository rule still applies: every Robot Framework keyword must include `[Documentation]`.

## Important Constants And Variables

Primary files:

- `src/data/CONSTANTS.yaml`: shared constants, channels, ticket types, product types, fund provider business IDs, LMS account types, LMS fee types, payment gateways, repayment options, settlement methods, and known business IDs.
- `src/data/lms/CONSTANTS.yaml`: LMS-specific constants where present.
- `src/data/lms/purchase-bnpl.yaml`: dashboard credentials, Company credentials, min/over amount, manifest Platform version, and test business ID.
- `src/config/environment-stage.yaml`: UAT base URLs, microservice paths, DB connection details, business IDs, usernames, and password variables.

Frequently used values:

| Constant group    | Examples                                                                                                                                                |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Account types     | `${LMS_Account_Type_1PAY}`, `${LMS_Account_Type_XPAY}`, `${LMS_Account_Type_CREDIT}`, `${LMS_Account_Type_INSTALLMENT_SALE}`                            |
| Fee types         | `${LMS_ZERO_FEE}`, `${LMS_FEE_ON_PURCHASE}`, `${LMS_FEE_ON_INSTALLMENT}`, `${LMS_FEE_ON_ALLOCATION}`                                                    |
| Fund providers    | `${LMS_FP_PLATFORM}`, `${LMS_FP_TEJARAT}`, `${LMS_FP_SADERAT}`, `${LMS_FP_MELLAT}`, `${LMS_FP_COMPANY}`                                                 |
| Channels          | `${CHANNEL.API}`, `${CHANNEL.UPG}`, `${CHANNEL.SMART_POS}`, `${CHANNEL.QR}`, `${CHANNEL.BARCODE}`, `${CHANNEL.LINUX_POS}`, `${CHANNEL.PAYMENT_LINK}`    |
| Gateways          | `${LMS_PAYMENT_GATEWAY.BPG}`, `${LMS_PAYMENT_GATEWAY.CPG}`, `${LMS_PAYMENT_GATEWAY.ISPG}`, `${LMS_PAYMENT_GATEWAY.CAPG}`, `${LMS_PAYMENT_GATEWAY.CASH}` |
| Repayment options | `${LMS_REPAYMENT_OPTION.ONEPAY}`, `${LMS_REPAYMENT_OPTION.XPAY}`                                                                                        |

## Database Usage

Credit-core tests use the shared DB services from `src/services/db/`. Keep all DB operations through those service files, not direct library calls in feature files.

Common DBs and collections/tables seen in credit-core:

| DB/service area          | Typical use                                                                |
| ------------------------ | -------------------------------------------------------------------------- |
| `credit_mng_db`          | Purchases, prepayments, refunds, billing cycles, profiles, fund providers. |
| `credit-account-mng_db`  | Accounts, profiles, block details, manual closes, status checks.           |
| `credit_merchant_mng_db` | Merchant settlement/gateway records.                                       |
| `report_mng_db`          | Activities, dashboard/user transaction records.                            |
| `residue_mng_db`         | Residue profiles and credit residue records.                               |
| `notification_db`        | SMS journal checks for refunds/residue.                                    |
| `switch_credit_db`       | Activation records.                                                        |
| `wallet_provider_db`     | Wallet documents and balance alignment checks.                             |
| `installment_db`         | Installment contract status and fund provider propagation.                 |

Be careful with direct update keywords such as `Mongo Db Update One`, `Mongo Db Update Many`, and `MySQL Execute Query`; these are usually used to force test state for lifecycle scenarios. Add clear `[Documentation]` on any new helper that mutates data.

## Common Test Patterns

### Merchant Initialization

Many suites call `Initialize Merchant` in `Test Setup`. The setup creates a merchant/business with required wallets:

- `spend`
- `credit-spend`
- `debit-settlement`
- `credit-settlement`

It stores the resulting business ID in `${LMS_AUTOMATION_BUSINESS_ID}`.

### Credit Allocation

Allocation usually calls `Activate Account` from `services/backend/import-allocation.resource`. Step wrappers set test variables such as:

- `${cell_number}`
- `${user_id}`
- `${credit_ids}`
- `${user_object}`
- `${ALLOCATION_USER_LIST}`

Most teardown flows pass `${ALLOCATION_USER_LIST}` to amount reproduction helpers, so keep it updated when adding tests with multiple users.

### Gateway State

Gateway tests commonly set:

- payment channel
- payment gateway
- repayment options
- business ID

Then they call activate/disable APIs. If a test enables a gateway, make sure teardown disables or restores it where the surrounding file already does so.

### Purchase Lifecycle

Online purchase flow:

```text
ticket -> prepare -> route info -> pay -> verify -> deliver
```

Offline purchase flow:

```text
init -> pay credit/cash as needed -> verify -> deliver
```

The service keywords return and reuse `ticket`, `tracking_code`, `purchase_id`, and API response dictionaries. Assertions often validate both API status and database/report propagation.

### Expiration, Residue, And Close

Expiration and close tests may force scheduler-like behavior by updating DB records directly. The purpose is to avoid waiting for production schedulers. When adding cases, prefer existing service keywords:

- `Expire credit account`
- `Close billing cycles`
- `Close Account`
- `Make Account Closable`
- `Change initial balance to balance on expiration`

## Handover Notes For Maintenance

- Add new scenarios in feature files only after checking if a similar step keyword already exists. The large matrix files contain many reusable one-line business steps.
- Keep API wrappers thin. Do not put business assertions or DB mutations inside `src/apis/lms/credit-core/`.
- Keep cross-team reusable flows in `src/services/backend/LMS/credit-core/`.
- Use service layer functions from other teams instead of importing their step resources directly.
- Use `src/services/db/` for all database operations.
- Preserve `Test Teardown` cleanup in files that allocate credit, charge wallets, or change gateway state.
- Be cautious with global/static business IDs such as Company and LMS test merchant IDs; many tests can affect the same state.
- When adding a Robot keyword, include `[Documentation]`. This is mandatory in this repository.
- Follow the existing path style in API files. For credit-core microservice calls, replace the generic onboarding path with the correct microservice path such as `${MS_CREDIT_MNG_PATH}` or `${MS_CREDIT_ACCOUNT_MNG_PATH}`.
- Prefer explicit assertions with useful failure messages. Existing tests often fail with context about which DB or response field is inconsistent.
