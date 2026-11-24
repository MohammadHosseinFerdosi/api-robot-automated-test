*** Settings ***
Library         Collections
Resource    apis/purchase-mng/refund/get-purchases-refunds-inquiry-id.resource
Resource    steps/payment/purchases-refund-inquiry-step.resource
       
*** Test Cases ***
Get refund inquiry with valid inquiry id 
    
    [Template]   Run refund inquiry with providerId and trakingCode and check response
    ValidWallet    providerId    7ecc14c8-336b-4bf1-a3d2-002a845aa194
    ValidWallet    trackingCode    8191843271728811026725
    ValidIban    trackingCode    11988051571593929197689
    ValidIban    providerId    0705103639


Get refund inquiry with invalid inquiry id
    [Template]   Run refund inquiry with providerId and trakingCode and check response
    InValid    providerId    1f8d08a1-3c12-4ece-a85c-5aa577575e655620f1d1c6 
    InValid    trackingCode    19532rgtr728881673090528677258 
  
Get Refund Inquiry With Provider_Id And Different Refund's Username
    [Template]   Run Refund inquiry with Different Refund's Username 
    RefundWithDigPay-RefundInquiryWithCompany-ProviderId    7ecc14c8-336b-4bf1-a3d2-002a845aa194 
    RefundWithDigPay-RefundInquiryWithCompany-TrackingCode    11988051571593929197689