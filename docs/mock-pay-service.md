# 🪼 Mock Payment Service


> Overview
This Robot Framework keyword automates the end-to-end purchase flow for a newly created business using a mocked PSP (Payment Service Provider).

> The scenario is:

1. A new business is created with wallets, purchase settings, and ticket configuration.

2. A mock IPG terminal is assigned to that business.

3. A new user is registered.

4. The business initiates a purchase (ticket request).

5. The user selects the mocked PSP (IPG).

6. The purchase is processed, and the PSP mock returns a result (${purchase_status}).

7. Tracking information (trackingCode, traceId, etc.) is extracted for validation.

> Keyword:
1. Create a New Business with Purchase Settings, Ticket Configuration, Assign a Mock IPG Terminal, and Perform a Payment on the Mock PSP

> Arguments
1. ${prefix_cellnumber} → Prefix for generating a new test user phone number.

2. ${purchase_status} → Desired purchase result (e.g., SUCCESS, FAILED).

3. ${amount} → Transaction amount.

4. ${agent} → User agent or channel (e.g., WEB, APP).

> Flow Breakdown:

1. [Business Creation]

    Initializes a new business with wallets for spend and refund.

    Assigns business roles.

2. [Configuration Setup]

    Defines purchase settings and ticket configurations.

    Activates payment gateways.

3. [Assign Mock PSP]

    Logs in to the dashboard.

    Assigns a mocked PSP/IPG terminal to the business.

4. [User Creation]

    Generates a random provider ID.

    Creates a new end user with a unique cell number.

5. [Ticket Creation]

    Business logs in and requests a purchase ticket for the user.

    Ticket details are retrieved for validation.

6. [IPG Selection]

    The user selects the mocked PSP/IPG for payment.

7. [Purchase & Tracking]

    Purchase data is fetched from MongoDB (trackingCode, traceId).

    PSP token is retrieved from the switch database.

    A simulated PSP result is posted with ${purchase_status}.

    Final PSP confirmation is sent with transaction details (rrn, sale_order_id).

> Key Outputs:

The keyword sets test variables for later validation:

1. ${purchase_tracking_code} → Unique tracking code for the purchase.

2. ${purchase_traceId} → Trace ID of the transaction.

3. ${psp_token} → PSP transaction token.

4. ${rrn} and ${sale_order_id} → PSP settlement details.

5. ${psp_result} → Final PSP confirmation result.

> Notes:

This test depends on connections to MongoDB and backend microservices (Purchase Manager, Switch PSP, etc.).

The ${purchase_status} drives the result flow:

1. SUCCESS → Simulates a successful PSP payment.

2. FAILED → Simulates a failed PSP payment.

Useful for integration testing of purchase flows without a real PSP.