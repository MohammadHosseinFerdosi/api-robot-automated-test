# 💸 Import Allocation Services 


The **Import-Allocation Service** is a service in Robot Framework designed to assign users to different `group_ids`, provided these IDs are importable. This service can be used in two primary ways:

1. **Random User Allocation**: The service can randomly assign a user to one of the specified `group_ids`.
2. **Pre-defined User Allocation**: Alternatively, it can allocate a specific, pre-defined user to one or more `group_ids`.

This guide aims to provide a seamless experience when using the components of the Import-Allocation Service, offering step-by-step instructions on how to integrate and use its functions effectively.



## 📑 Description

An important step in most of our automated testing is ensuring that the user has an active plan. To follow any purchase flow, generate and pay installments, automate transactions, pursue various UI/UX flows, and more, access to an active account is essential. While replicating the exact journey that a typical user follows to get allocated to a `group_id` is a complex task — and is most beneficial when focusing on the allocation process itself rather than other flows — having a service to directly allocate a user is crucial when testing other flows.

That being said, generating a random allocation for a user aligns with the test automation guidelines. Creating a new user for each test case scenario helps mitigate potential false alarms caused by faulty or incomplete user accounts.

To address these challenges, we are introducing the **"import-allocation"** service. This service supports two key features: **(a) random allocation** and **(b) specific user allocation**. The interface and functions/keywords are designed to offer a seamless user experience. This guide will assist future developers and maintainers in keeping the service up to date and in utilizing it effectively for automation or personal use.

> **Note**  
> This guide is a starting point for getting familiar with the functionality of the service. For each keyword added by this service, there is a dedicated documentation section. Make sure to check them out, as they contain useful information about the arguments and conditions of each keyword.


# Table of Contents

1. [Getting Started](#▶️-getting-started)
2. [API](#🛜-api)
3. [Post Credit User Admin Upload](#🌐-post-credit-user-admin-upload)
4. [Generate a Random Allocation](#💵-generate-a-random-allocation)
5. [Optional Arguments](#♾️-optional-arguments)
6. [Allocation Specific Amount for a Specific User](#💶-allocation-specific-amount-for-a-specific-user)
7. [Allocation Group IDs](#🗄️-allocation-group-ids)
8. [Other CONSTANTS](#🔖-other-constants)
9. [Python Library](#📖-python-library)
10. [Data and Seatures](#🔰-data-and-features)
11. [Import Allocation Service](#🪼-import-allocation-service)
12. [Reminders](#🎗️-reminders)

# ▶️ Getting Started

To begin using the service, you should directly import the service file and use its non-private utilities in your "step" layer.

To **directly** use the utilities, simply include the import-allocation resource in your code.

```bash
Resource        services/backend/import-allocation.resource
```

Here is an example of using the main keywords provided by the allocation services:

``` bash
Credit Allocation
    [Arguments]    ${types}    ${set_variables_as}=TEST    &{optional_arguments}

    ${user_object}    Activate Account
    ...    types=${types}
    ...    &{optional_arguments}

    ${cell_number}    Set Variable    ${user_object['user_cell_number']}
    ${user_id}    Set Variable    ${user_object['user_id']}
    ${credit_ids}    Set Variable    ${user_object['user_credit_ids']}
    &{user_data}    Create Dictionary    user_id=${user_id}    type=${CUSTOMER_TYPE}
    ${ALLOCATION_USER_LIST}    Create List    ${user_data}

    IF    '${set_variables_as}'=='TEST'
        Set Test Variable    ${cell_number}
        Set Test Variable    ${user_id}
        Set Test Variable    ${credit_ids}
        Set Test Variable    ${user_object}
        Set Test Variable    ${ALLOCATION_USER_LIST}
    END
    IF    '${set_variables_as}'=='SUITE'
        Set Suite Variable    ${cell_number}
        Set Suite Variable    ${user_id}
        Set Suite Variable    ${credit_ids}
        Set Suite Variable    ${user_object}
        Set Suite Variable    ${ALLOCATION_USER_LIST}
    END
```

To use this keyword, users should import this in their step layers. 

``` bash
    Credit Allocation   types=${{['${LMS_Account_Type_1PAY'}]}}
    Credit Allocation    
    ...    types=${{['${LMS_Account_Type_CREDIT}', '${LMS_Account_Type_1PAY}', '${LMS_Account_Type_XPAY}']}}    
    ...    amounts=${{['10000','11000','12000']}} 
```

# 🛜 API

In this section, we are going to introduce changes made to the API layer. As of today, apart from minor fixes and changes to other APIs which are apparent through the history of commits, this service only relies on one API.

## 🌐 Post Credit User Admin Upload

This API is used to upload a file to the designated `group_id`. The file must adhere to a special template. If you already have the proper template, you can directly use this API to upload it to the dashboard.

> If your file does not match the required format and template outline for the desired group, your test will fail.

In the import-allocation service, we are directly using the microservices to upload files, as using the gateway method limits the number of allocation in a time interval and might increase the false alarms.


```bash
POST Credit Users Admin Upload  ${api_call_side}    ${group_id}    ${file}  ${user_id} 
```

The input arguments are:

- ```${api_call_side}```: This argument defines the API path. As of the writing of this document, the only valid input for this argument is ```${MICROSERVICE_SIDE}```.

- ```${group_id}```: This represents the group ID of the group you wish to allocate to.

- ```${file}```: This argument is the file descriptor of a specified file to be passed as the `data` parameter to other request keywords. To pass a file this way, you must first pass it through the `Get File For Streaming Upload` keyword.

- ```${user_id}```: Is the user id used to log in to the Dashboard . Typically this variable is set as `${DASHBOARD_USERNAME}`

For example, if you have a template file named `my_template.xlsx`, and you want to upload it into a ```${dummy_group_id}```, you would do the following:

```bash
${file}    Get File For Streaming Upload    ${path_to_file}/my_template.xlsx

POST Credit Users Admin Upload    ${MICROSERVICE_SIDE}    ${group_id}    ${file}    ${user_id}
```

Ideally, you shouldn't need to directly use the API, as using the service itself should suffice.

# 💵 Generate a Random Allocation

Often, in your automation, you require an account with various active or inactive plans. The first step in achieving this is to allocate the user to one or more groups.

The groups are defined by a `group_id`, which you can find in the `../data/CONSTANTS.yaml` file. A complete description of these IDs will be provided in later sections.

To **directly allocate** a random user (with a random cell number and a random national code) to one or more `group_id`s, you should use the `Generate Multi Allocation` keyword from the service.

For example, to allocate a randomly generated user to 4 groups — namely: BNPL 1pay, BNPL 4pay, Tejarat Bank C Credit, and Company C Credit — you should first define them as a list and then pass them through the `Generate Multi Allocation` keyword.


```bash
    @{group_ids}    Create List   ${LOS_DP-1INST-NOFEE-SOFTPENALTY-NOACTION-USERPAYS}  
    ...    ${LOS_DP-3INST-NOFEE-JUSTPENALTY-NOACTION-USERPAYS}
    ...    ${LOS_TB-6INST-NOFEE-JUSTPENALTY-NOACTION-USERPAYS}
    ...    ${LOS_CO-6INST-PURCHASEFEE-JUSTPENALTY-NOACTION-USERPAYS-30DAYS}

    ${cell_number}    ${credit_ids}    ${user_id}   ${additional_info}    Generate multi allocation    group_ids=${group_ids}
```
An important detail in the implementation of the keyword is that you should **always** ensure to **include** the name of the input variable and not just pass them as raw values. The most commonly used keywords in this service are designed to accept an arbitrary number of inputs, providing flexibility and convenience.

The function will then output the `cell_number`, a list of `credit_ids`, and the `user_id` of the allocated user.

Apart from `group_ids`, which is mandatory, you can pass any number of additional inputs. The majority of these inputs are stored in a dictionary. A common practice in Python programming, when the number of input variables is large, is to pass them through a dynamic dictionary defined as `**configs`. Similarly, in Robot Framework, we can define these variables as a single dynamic dictionary, such as `&{configs}`. 

To access values in the keyword, for example, `group_ids`, you can use `${configs['group_ids']}`.

**Another approach** is to use our pre-defined keywords. You can easily call the keyword from our step layer, provided that you have properly imported the steps into your code.


```bash
    Activate Account    types=${{['${LMS_Account_Type_1PAY}','${LMS_Account_Type_XPAY}']}}
```

# ♾️ Optional Arguments

The core service `Generate multi allocation`, which is also used in the keywords accessible through the step layers, utilizes the same optional arguments. Here is a list of these arguments:

1. ```@{inst_counts}```: A list of installment counts for each of the `group_ids` provided. If not given, the allocation automatically searches the database and sets the appropriate values for the installment counts.

2. ```@{amounts}```: A list of amounts to be allocated. If none is given, a default amount is set for all allocations.

3. ```${default_amount}```: The default amount value. If no amount is provided, this default value is used. If no default value is provided, a pre-defined default value is set.

4. ```@{file_names}```: A list of file names. These are used to generate the templates to be uploaded to the dashboard. If none is provided, pre-defined names are used.

5. ```@{CRNs}```: A list of CRNs for the allocation. If none is provided, the CRN is extracted from the database and replaced.

6. ```${cell_number}```: The cell number of the user to be allocated. If none is provided, a random cell number is generated.

7. ```${national_code}```: The national code of the user to be allocated. If none is provided, a random national code is generated.

   **--Note**: Make sure to include either both ```${cell_number}``` and ```${national_code}``` or neither. The allocation will fail if you include only one.

9. ```@{delete_templates}```: A list of boolean values indicating whether to delete the generated templates from the local device. If not provided, all generated templates are deleted.

10. ```${pin_code}```: A string representing the pin code of the user, used for login. Needed for pre-defined allocations with users containing a pin code for their login. Since users with a ```${pin_code}``` have already had their user records created, the step where we would normally log in to generate a user record in the ```users_db.users``` table is skipped.
>   Make sure you include a random pin_code to by pass the login process; 

11. ```${default_amounts_list}```: Similar to ```${default_amount}```, but creates a list instead that is assigned to each allocation in order of allocating.

> **Note**:  
> When you want to allocate for a specific user, make sure that the national code is consistent with the previous allocations done for the same user. You will get a "**Fail**" message if your national code doesn't match.  
> You should also include either both ```${cell_number}``` and ```${national_code}``` together, or neither of them at all.
> We recommend to use only the optional values ```${cell_number}```,  ```${national_code}```,  and ```${default_amount}``` for specific allocation cases. 


# 💶 Allocating a Specific Amount for a Specific User

First, make sure that the account is **capable of having the plan** you're going to import them to. Then, as mentioned in the optional arguments section, you can pass both ```${cell_number}``` and ```${national_code}``` and the allocation will be carried out for that specific user. To allocate with a specific amount (other than the default value), simply override the ```${default_amount}``` by passing it as an option.

To **directly** allocate a user to one or more `group_id`s, you should use the `Generate Multi Allocation` keyword from the service, with both ```${cell_number}``` and ```${national_code}``` as input arguments.

For example, to allocate a user with:
- ```${cell_number}=09911772110```
- ```${national_code}=3242015444```
- ```${default_amount}=123456```

on 4 groups — namely: BNPL 1pay, BNPL 4pay, Tejarat Bank C Credit, and Company C Credit — you should first define them as a list and then pass them through the `Generate Multi Allocation` keyword.


```bash
    @{group_ids}    Create List   ${LOS_DP-1INST-NOFEE-SOFTPENALTY-NOACTION-USERPAYS}  
    ...    ${LOS_DP-3INST-NOFEE-JUSTPENALTY-NOACTION-USERPAYS}
    ...    ${LOS_TB-6INST-NOFEE-JUSTPENALTY-NOACTION-USERPAYS}
    ...    ${LOS_CO-6INST-PURCHASEFEE-JUSTPENALTY-NOACTION-USERPAYS-30DAYS}

    ${cell_number}  Set Variable    09911772110

    ${national_code}    Set Variable    3242015444

    ${default_amount}   Set Variable    12345

    ${cell_number}    ${credit_ids}    ${user_id}   ${additional_info}    Generate multi allocation    
    ...     group_ids=${group_ids}    
    ...     cell_number=${cell_number}  
    ...     national_code=${national_code}      
    ...     default_amount=${default_amount}
```

**Another approach** to do this, is use our pre-defined keywords. You can easily call the keyword from our step layer, given you have properly imported the steps in you code:

```bash
    Activate Account     
    ...     types=${{['${LMS_Account_Type_1PAY}','${LMS_Account_Type_XPAY}'',${LMS_Account_Type_CREDIT}','${LMS_Account_Type_CREDIT}']}}       
    ...     fund_providers=${{['${LMS_FP_PLATFORM}','${LMS_FP_PLATFORM}','${LMS_FP_TEJARAT}'',${LMS_FP_COMPANY}']}}     
    ...     cell_number=09911772110     
    ...     national_code=3242015444    
    ...         default_amount=12345
```

# 🗄️ Allocation Group Ids

```group_ids``` are found in the ```CONSTANTS.yaml``` file. Each `group_id` has a unique name that you can find in the dashboard to explore more details about them. Below is a summary of what each group is designed to do:

- **LOS_DP-1INST-NOFEE-SOFTPENALTY-NOACTION-USERPAYS:** A 1pay account with no fee
- **LOS_DP-1INST-noFee-justPenalty-manualSettle-underwriterPays:** A 1pay Account with no fee but manual settlement
- **LOS_DP-1INST-noFee-justPenalty-manualOverdue-underwriterPays:** A 4pay account with no fee but manual overdue

- **LOS_DP-3INST-NOFEE-JUSTPENALTY-NOACTION-USERPAYS:** A 4pay account with no fee
- **LOS_DP-3INST-INSTFEE-HARDPENALTY-MANUALSETTLE-UNDERWRITER-CRN:** A 4pay account with installment fee and manual settlement
- **LOS_DP-3INST-INSTFEE-HARDPENALTY-MANUALOVERDUE-UNDERWRITER-CRN:** A 4pay account with installment fee and manual overdue
- **LOS_DP-3INST-PURCHASEFEE-HARDPENALTY-NOACTION-USERPAYS:** A 4pay account with purchase fee
- **LOS_DP-3INST-INSTFEE-SOFTPENALTY-NOACTION-USERPAYS-STARTIN3MONTHS:** A 4pay account with installment fee
- **LOS_DP-3INST-FeeOnAllocation-justPenalty-noAction-userPays:** A 4pay account with fee on Allocation

- **LOS_SD-6INST-NOFEE-JUSTPENALTY-NOACTION-USERPAYS:** A c_credit account with no fee (Saderat)
- **LOS_SD-6INST-INSTFEE-JUSTPENALTY-MANUALSETTLE-UNDERWRITER-CRN:** A c_credit account with installment fee and manual settlement (Saderat)
- **LOS_SD-6INST-INSTFEE-JUSTPENALTY-MANUALOVERDUE-UNDERWRITER-CRN:** A c_credit account with installment fee and manual overdue (Saderat)
- **LOS_SD-6INST-INSTFEE-JUSTPENALTY-NOACTION-USERPAYS-STARTIN3MONTHS:** A c_Credit account with installment fee (Saderat)
- **LOS_SD-6INST-FeeOnPurchase-justPenalty-noAction-userPays:** A c_credit account with fee on purchase (Saderat)
- **LOS_SD-6INST-FeeOnAllocation-justPenalty-noAction-userPays:** A c_credit account with fee on allocation (Saderat)
- **LOS_SD-6INST-FeeHybric-CreditInterest-justPenalty-noAction-userPays:** A  c_credit account with hybird fee (Saderat)

- **LOS_TB-6INST-NOFEE-JUSTPENALTY-NOACTION-USERPAYS:** A c_credit account with no fee (Tejarat) 
- **LOS_TB-6INST-INSTFEE-JUSTPENALTY-MANUALSETTLE-UNDERWRITER-CRN:** A c_credit account with installment fee and manual settlement (Tejarat) 
- **LOS_TB-6INST-INSTFEE-JUSTPENALTY-MANUALOVERDUE-UNDERWRITER-CRN:** A c_credit account with installment fee and manual overdue (Tejarat) 
- **LOS_TB-6INST-INSTFEE-JUSTPENALTY-NOACTION-USERPAYS-STARTIN3MONTHS:** A c_Credit account with installment fee (Tejarat) 
- **LOS_TB-6INST-FeeOnPurchase-justPenalty-noAction-userPays:** A c_credit account with fee on purchase (Tejarat)
- **LOS_TB-6INST-FeeOnAllocation-justPenalty-noAction-userPays:** A c_credit account with fee on allocation (Tejarat)
- **LOS_TB-6INST-FeeHybric-CreditInterest-justPenalty-noAction-userPays:** A  c_credit account with hybird fee (Tejarat)

- **LOS_MLT-6INST-NOFEE-JUSTPENALTY-NOACTION-USERPAYS:**  A c_credit account with no fee (Mellat)
- **LOS_MLT-6INST-INSTFEE-JUSTPENALTY-MANUALSETTLE-UNDERWRITER-CRN:** A c_credit account with installment fee and manual settlement (Mellat) 
- **LOS_MLT-6INST-INSTFEE-JUSTPENALTY-MANUALOVERDUE-UNDERWRITER-CRN:** A c_credit account with installment fee and manual overdue (Mellat)
- **LOS_MLT-6INST-INSTFEE-JUSTPENALTY-NOACTION-USERPAYS-STARTIN3MONTHS:**  A c_Credit account with installment fee (Mellat)
- **LOS_MLT-6INST-FeeOnPurchase-justPenalty-noAction-userPays:** A c_credit account with fee on purchase (Mellat)
- **LOS_MLT-6INST-FeeOnAllocation-justPenalty-noAction-userPays:** A c_credit account with fee on allocation (Mellat)
- **LOS_MLT-6INST-FeeHybric-CreditInterest-justPenalty-noAction-userPays:** A  c_credit account with hybird fee (Mellat)

- **LOS_CO-6INST-PURCHASEFEE-JUSTPENALTY-NOACTION-USERPAYS-30DAYS:** A c_credit account with fee on purchase and per billing cycle (Company)

- **LOS_DP-4INST-InstSales-purchaseFee:** An installment_sales account with fee on purchase
- **LOS_DP-4INST-InstSales-allocationFee:** An installment_sales account with fee on allocation
- **LOS_DP-4INST-InstSales-installmentFee:** An installment_sales account with fee on installment
- **LOS_DP-4INST-InstSales-noFee:** An installment_sales account with no fee
- **LOS_DP-4INST-InstSales-noFee-manualSettle:** An installment_sales account with no fee but manual settlement
- **LOS_DP-4INST-InstSales-noFee-manualOverdue:** An installment_sales account with no fee but manual overdue

- **LOS_DP-3INST-noFee-justPenalty-noAction-userPays-3PAY:** A 3pay account with no fee 
- **LOS_DP-3INST-noFee-justPenalty-manualSettle-underwriterPays-3PAY:** A 3pay account with no fee but manual settlement
- **LOS_DP-3INST-noFee-justPenalty-manualOverdue-underwriterPays-3PAY:** A 3pay account with no fee but manual overdue

The allocation amount for all of these groups is dynamic. The installment count is as follows:
- **1pay**: 1 installment
- **4pay**: 3 installments
- **C_Credit Accounts**: 6 installments
- **Installment Sales**: 4 installments

Depending on your needs, you can allocate on any of these groups.

# 🔖 Other CONSTANTS

Aprart from the Group IDS, we included a set of constant variables for different fund providers, differet allocaiton types (also know as credit or service types), and different fee types. A combination of these (fund provider and fee type) would yeild to a different ```group id``` defined in the previous section. 

CONSTANT variables for different fund providers are:
- ```LMS_FP_PLATFORM```: DP
- ```LMS_FP_TEJARAT```: TB
- ```LMS_FP_SADERAT```: SD
- ```LMS_FP_MELLAT```: MLT
- ```LMS_FP_COMPANY```: CO

CONSTANT variables for different fee types are:
- ```LMS_ZERO_FEE```: ZERO_FEE
- ```LMS_ZERO_FEE_AND_MANUAL_SETTLE```: ZERO_FEE_AND_MANUAL_SETTLE
- ```LMS_ZERO_FEE_AND_MANUAL_OVERDUE```: ZERO_FEE_AND_MANUAL_OVERDUE
- ```LMS_FEE_ON_INSTALLMENT```: FEE_ON_INSTALLMENT
- ```LMS_FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE```: FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE
- ```LMS_FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE```: FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE  
- ```LMS_FEE_ON_PURCHASE```: FEE_ON_PURCHASE 
- ```LMS_FEE_ON_ALLOCATION```: FEE_ON_ALLOCATION
- ```LMS_HYBRID_FEE_CREDIT_INTEREST```: HYBRID_FEE_CREDIT_INTEREST 

# 📖 Python Library

These services come with a set of Python utilities mainly used to generate templates, dump files, and delete such files.

### Functions:

- **`create_dump`**: This function creates a dump file with the provided values and headers. It appends each row of values to the existing dump file or creates a new dump file if one does not already exist.

- **`fake_national_code`**: This function generates a fake social security number (SSN).

- **`fake_cell_number`**: This function generates a random cell number with a random prefix from this list ["983", "984", "985", "986", "987", "988", "989"] .

- **`create_template`**: This function creates an individual-user or organizational template for import or allocation. The inputs are as follows:

    - `inst_count`: **Int**; the installment count.
    - `amount`: **Int**; the amount of the loan.
    - `save_path`: **String**; the location where the template will be saved.
    - `default_information`: **String**; the path to the default import values (must be a YAML file).
    - `CRN`: **None or Int**; If `None`, the allocation is individual. If an integer is provided, the allocation is organizational.
    - `cell_number`: **String or None**; If `None`, a randomly generated cell number will be used.
    - `national_code`: **String or None**; If `None`, a randomly generated SSN will be used.
    - `kwargs`: **Dictionary or None**; If provided, the template is created using these details. Optional `kwargs` include:
        - `"name"`: **String**; The name of the user (e.g., کاربر).
        - `"surname"`: **String**; The surname of the user (e.g., تست).
        - `"gender"`: **String**; The gender of the user (e.g., مرد).
        - `"score"`: **String**; The Platform score of the user (e.g., 800).
        - `"birthdate"`: **String**; The birthdate of the user in `YYYY/MM/DD` format (e.g., 1313/12/31).
        - `"postal_code"`: **String**; The postal code of the user (e.g., 1461755535).
        - `"provenance"`: **String**; The provenance of the user (e.g., تهران).
        - `"city"`: **String**; The city of the user (e.g., تهران).
        - `"address"`: **String**; The address of the user (e.g., تهران - شرکت کمپانی‌پی).
        - `"number"`: **String**; The number of the user (e.g., 2).
        - `"unit"`: **String**; The unit of the user (e.g., 3).
        - `"phone_number"`: **String**; The phone number of the user (not to be confused with the user's `cell_number`, e.g., 02133438607).

- **`delete_template`**: This function deletes a file using the specified `file_path`.


```python
#  Examples ...

create_template(inst_count=6,
                amount=30000,
                save_path="./data/los/dummy-import-allocation-template.xlsx",
                default_information="./data/los/default-import-information.yaml", 
                CRN=None,
                name = "کاربر",
                surname = "تست",
                birthdate = "1313/13/13",
                city = "تهران"
                )
                    

delete_template(file_path="./data/los/dummy-import-allocation-template.xlsx")
 ```

 # 🔰 Data and Features

The default variables and constants used in the service are defined in the `data` layer. The `CONSTANTS.yaml` file contains the `group_ids` as a key-value pair, along with other relevant and default variables that are used for generating the templates, such as `default-import-information.yaml`, or for connecting to the dashboard and naming the files, which are defined in the `los` directory.

The information used for initiating the installments is defined in the `lms/initiate-installment-config.yaml` file. This file contains the necessary details for initiating **On_Allocation** services.

The `features` layer contains automated tests, which can also serve as example use cases for this service. Make sure to review them if you're unsure how to use the services effectively.

# 🪼 Import Allocation Service

In this section, we will introduce the keywords and functions created in the core service file. These keywords are directly used as checking steps to both alleviate the user allocation experience and ensure that the allocation is carried out properly.

- ``Find User National Code If Any``: Searches the `switch_credit_db.users` table and `users_db.users` table to find the national code, if it exists. Users who have previously logged into the system or have had a successful allocation will have a user record in the `users_db.users` table. If the national code is already included, there should be no need to update it in future steps, as updating it to a wrong national code may cause issues.

- ``Update User Database by National Code``: Updates the `users_db.users` table to include the national code. This is required for users allocated randomly who haven't been part of the system previously.

- ``Delete File Account Name``: Deletes the uploaded file from the `switch_credit_db.user_bulk` table, allowing the same file name to be uploaded again.

- ``Find Status by Credit Id``: Finds the status of a given credit ID and returns it.

- ``Find Service Type by Credit Id``: Finds the service type of a given credit ID and returns it.

- ``Find User Id by Credit Id``: Finds the user ID of a given credit ID and returns it.

- ``Find Credit Ids by Cell Number``: Finds the credit IDs for a given cell number that are ACTIVE. It can be filtered to return the credit ID for a specific allocation based on the `group_id`.

- ``Is Allocation Complete``: Searches the `switch_credit_db` to ensure that the allocation was successful. It fails if it cannot find an active plan for the given `group_id`. Input arguments are `cell_number` and `group_id`. Returns the `credit_id` of the successful allocation.

- ``Upload File For User``: Logs into the dashboard via `username: ${DASHBOARD_CREDIT_USERNAME}` and `password: ${DASHBOARD_CREDIT_PASSWORD}`. If the login is successful, it deletes the `file_name` from `database_name -> delete_from_collection` and then uploads a user's template to be allocated to the `group_id`.  
    - **Mandatory Input Arguments**: `${group_id}`, `${file_name}`  
        - `${group_id}` can be any valid group ID that has been activated.  
        - `${file_name}` is the name of the file/template being uploaded to the dashboard into the given `group_id`.  
    - **Optional Input Arguments**: `${cell_number}`  
    - `${cell_number}` is the cell number of the user being activated. It is used to verify whether the allocation was successful or not. This is a mandatory input, but the keyword can still work without it.  
    >**Note**:    
    >If the upload fails (due to an invalid `${cell_number}`, `${national_code}`, or unnecessary fields), the test will fail. However, if the template includes incorrect information (e.g., incorrect `${inst_counts}`), the allocation will fail, but the test will be marked as passed due to the API's internal handling of the response.

    >If the allocation fails, it is identified by checking the `Find Credit Ids by Cell Number` result (length of 0 or non-ACTIV` status).

- ``Find Rule Id via Group Id``: Finds the `rule_id` of a given `group_id` and returns it.

- ``Find Profile Id via Rule Id``: Finds the `profile_id` of a given `rule_id` and returns it.

- ``Find Installment Count via Group Id``: Finds the installment count for a given `group_id` and returns it.

- ``Find Installment Count via Group Id``: Finds the minimum `installment_count` for a given `group_id` and returns it. This can also work if the `rule_id` is directly provided.

- ``Find CRN via Group Id``: Finds the `crn` of a given `group_id` and returns it.

- ``Find Fund Provider Code via Group Id``: Finds the `fund_provider_code` of a given `group_id` and returns it.

- ``Find Installment Generation Type via Group Id``: Finds the `contract_generation_type` of a given `group_id` and returns it. It can return boolean values or categorical values based on `${categorize}`.

- ``Initiate Installment``: Initiates the installment by updating the `external_contract_number` and `facility_bank_account_number` from the `installment_db`. The initiation may differ depending on the type of allocation and `fund_provider_code`. Some implementations may not be available, so you may see a log message: *"Not Implemented. Initialization is ignored!"*.  
    > **TEJARAT_BANK**: Currently available for initiation. It sets a predefined `external_contract_number` and `facility_bank_account_number`.

    > **MELLAT**: is somewhat done.

- ``Generate Multi Allocation``: This is the core function of the service. It generates a random user and allocates it to multiple `group_ids`. It returns the `cell_number` of the generated user as well as the list of `credit_ids` allocated and the `user_id`.  
    - **Mandatory Input**: 
        - `@{group_ids}`: A list of `group_ids`. It can include one or multiple `group_ids`.  
    - **Optional Inputs**: 
        - `@{inst_counts}`: A list of installment counts for each `group_id`. If not provided, the allocation will search the databases and set appropriate values.  
        - `@{amounts}`: A list of amounts to be allocated. If not provided, a default amount will be used for all allocations.  
        - `${default_amount}`: The default amount value. If no amount is provided, this value will be used. If not provided, a predefined default value will be used.  
        - `@{file_names}`: A list of file names used to generate the templates that will be uploaded to the dashboard. If not provided, predefined names will be used.  
        - `@{CRNs}`: A list of CRNs for the allocation. If not provided, the CRN will be extracted from the databases and replaced.  
        - `${cell_number}`: The cell number of the user to be allocated. If not provided, a random `cell_number` will be generated.  
        - `${national_code}`: The national code of the user to be allocated. If not provided, a random `national_code` will be generated.  
        - **Note**: Ensure that either both `${cell_number}` and `${national_code}` are provided, or neither. The allocation will fail if only one is provided.  
        - `@{delete_templates}`: A list of boolean values to indicate whether to delete the generated templates from the local device. If not provided, all generated templates will be deleted.  
        - `${pin_code}`: A string representing the pin code of the user used for login. This is required for pre-defined allocations where users already have a pin code. In such cases, the user record is already created, and the step to log in is skipped. 
        - And any other optional inputs related to the generation of the templates 

    - The allocation will return the `cell_number`, list of `credit_ids`, and `user_id` of the allocated user.  
- ```Activate Account```:  Based on the input variables, allocate a user or a randomly generated user on the `${group_ids}`. You should specify the Service-Type/Credit-Type of the allocation and if any extra options are required.

    Input Argument is:

    1. `${types}`: A List. Valid inputs are (Check the CONSTANT variables): 
        -   1PAY (```LMS_Account_Type_1PAY```)
        -   XPAY (```LMS_Account_Type_XPAY```)
        -   CREDIT (```LMS_Account_Type_CREDIT```)
        -   INSTALLMENT_SALE (```LMS_Account_Type_INSTALLMENT_SALE```)
         
    Optional Arguments are:

    1. `${fund_providers}`: A list of fund providers for the account.
        - Note: Only 1 CREDIT can be active with the exception of Company CREDIT. Valid inputs are (Check the CONSTANT variables): 
            - TB: Tejarat Bank; Only accessible to CREDIT. (```LMS_FP_TEJARAT```)
            - SD: Saderat; Only accessible to CREDIT. (```LMS_FP_SADERAT```)
            - MLT: Mellat; Only accessible to CREDIT. (```LMS_FP_MELLAT```)
            - CO: Company; Only accessible to CREDIT. (```LMS_FP_COMPANY```)
            - DP: Platform; Only accessible to 1PAY, XPAY, and INSTALLMENT_SALE. (```LMS_FP_PLATFORM```)

    2. `${fee_type}`: A list of fee types for the given allocation.
        - Valid input for 1PAY (```LMS_Account_Type_1PAY```) are:
            -    ZERO_FEE (```LMS_ZERO_FEE```)
            -    ZERO_FEE_AND_MANUAL_SETTLE (```LMS_ZERO_FEE_AND_MANUAL_SETTLE```)
            -    ZERO_FEE_AND_MANUAL_OVERDUE (```LMS_ZERO_FEE_AND_MANUAL_OVERDUE```)
        - Valid inputs for XPAY (```LMS_Account_Type_XPAY```) are:
            - FEE_ON_INSTALLMENT (```LMS_FEE_ON_INSTALLMENT```)
            - FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE (```LMS_FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE```)
            - FEE_ON_INSTALLMENT_AND_MANUAL_OVER_DUE (```LMS_FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE```)
            - FEE_ON_PURCHASE (```LMS_FEE_ON_PURCHASE```)
            - ZERO_FEE (```LMS_ZERO_FEE```)
            - FEE_ON_ALLOCATION (```LMS_FEE_ON_ALLOCATION```)
        - Valid inputs for CREDIT (```LMS_Account_Type_CREDIT```) are:
            - FEE_ON_INSTALLMENT (```LMS_FEE_ON_INSTALLMENT```)
            - FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE (```LMS_FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE```)
            - FEE_ON_INSTALLMENT_AND_MANUAL_OVER_DUE (```LMS_FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE```)
            - ZERO_FEE (```LMS_ZERO_FEE```)
            - FEE_ON_PURCHASE (```LMS_FEE_ON_PURCHASE```)
            - FEE_ON_ALLOCATION (```LMS_FEE_ON_ALLOCATION```)
        - Valid inputs for INSTALLMENT_SALE (```LMS_Account_Type_INSTALLMENT_SALE```) are:
            -    ZERO_FEE (```LMS_ZERO_FEE```)
            -    ZERO_FEE_AND_MANUAL_SETTLE (```LMS_ZERO_FEE_AND_MANUAL_SETTLE```)
            -    ZERO_FEE_AND_MANUAL_OVERDUE (```LMS_ZERO_FEE_AND_MANUAL_OVERDUE```)
            -    FEE_ON_ALLOCATION (```LMS_FEE_ON_ALLOCATION```)
            -    FEE_ON_INSTALLMENT (```LMS_FEE_ON_INSTALLMENT```)
            -    FEE_ON_PURCHASE (```LMS_FEE_ON_PURCHASE```)


    3. Other optional arguments include the configs passed to the `Generate multi allocation` Service. For further instructions, please check the service's documentation. For example: For a specific user allocation, include both `${cell_number}` and `${national_code}`; for a specific allocation amount, use `${default_amount}`.

    > **Note**:  
    > If the combination is not valid (which you can find what is valid and what is not in the last section), then the group id
    > will be set as ```NOT_SUPPORTED```. 

    > **Note:**   
    > If you want to do the allocation for a specific user, make sure you input **BOTH** `${cell_number}` and `${national_code}`, otherwise the test will fail.

    > **Guide**:   
    > To use a create a list in-line, you can use ```${{['item1','item2']}}``` sysntax

### Example Usage:

To allocate a specific user or with a specific name;  Remember you dont have to specify any of these but the ```group_ids``` as all of these are **OPTIONAL**.
```bash
@{group_ids}    Create List  ${LOS_DP-1INST-NOFEE-SOFTPENALTY-NOACTION-USERPAYS}

${cell_number}    ${credit_ids}    ${user_id}    Generate Multi Allocation    group_ids=${group_ids}    name=امیرمحمد

```

```bash
@{group_ids}    Create List  ${LOS_DP-1INST-NOFEE-SOFTPENALTY-NOACTION-USERPAYS}

${cell_number}    ${credit_ids}    ${user_id}    Generate Multi Allocation    group_ids=${group_ids}    cell_number=09911772110    national_code=3242015444    default_amount=123456

```

```bash
${cell_number}    ${credit_ids}    ${user_id}     Activate Account   types=${{[1PAY,XPAY,CREDIT,CREDIT]}}      fund_providers=${{[DP,DP,SD,CO]}}    

```
# 🎗️ Reminders

>**Valid Types are**:  
>-   1PAY (```LMS_Account_Type_1PAY```)
>-   XPAY (```LMS_Account_Type_XPAY```)
>-   CREDIT (```LMS_Account_Type_CREDIT```)
>-   INSTALLMENT_SALE (```LMS_Account_Type_INSTALLMENT_SALE```) 

>**Valid Fund Providers are**:  
>- TB: Tejarat Bank; Only accessible to CREDIT. (```LMS_FP_TEJARAT```)
>- SD: Saderat; Only accessible to CREDIT. (```LMS_FP_SADERAT```)
>- MLT: Mellat; Only accessible to CREDIT. (```LMS_FP_MELLAT```)
>- CO: Company; Only accessible to CREDIT. (```LMS_FP_COMPANY```)
>- DP: Platform; Only accessible to 1PAY, XPAY, and INSTALLMENT_SALE. (```LMS_FP_PLATFORM```)

>**Valid Fee Types are**:  
>- LMS_ZERO_FEE: ```ZERO_FEE```
>- LMS_ZERO_FEE_AND_MANUAL_SETTLE: ```ZERO_FEE_AND_MANUAL_SETTLE```
>- LMS_ZERO_FEE_AND_MANUAL_OVERDUE: ```ZERO_FEE_AND_MANUAL_OVERDUE```
>- LMS_FEE_ON_INSTALLMENT: ```FEE_ON_INSTALLMENT```
>- LMS_FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE: ```FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE```
>- LMS_FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE: ```FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE```  
>- LMS_FEE_ON_PURCHASE: ```FEE_ON_PURCHASE``` 
>- LMS_FEE_ON_ALLOCATION: ```FEE_ON_ALLOCATION```
>- LMS_HYBRID_FEE_CREDIT_INTEREST: ```HYBRID_FEE_CREDIT_INTEREST``` 

> **Guide**:   
> To use a create a list in-line, you can use ```${{['item1','item2']}}``` sysntax