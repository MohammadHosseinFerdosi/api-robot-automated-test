# 🪼 User Initializer Service

This document provides detailed information about the `fresh-user-initializer-service.resource` service.

This service is used to generate a fresh user and returns a dictionary containing the `user_info`. A fresh user is defined as a user who does not have a `user_id` in either the *switch_credit_db* or the *user_db*.

The service also includes a utility to generate a fresh user and retrieve the information of a previously generated user. This functionality is commonly used in the `import-allocation.resource`.

## Table of Contents

1. [Introduction](#🔰-Introduction)
1. [Installation](#🔱-Installation)
2. [Keywords](#♾️-Keywords)

## 🔰 Introduction

The service uses the utilities provided by the `library/faker_utils.py`. This library includes two functions: `fake_national_code` and `fake_cell_number`, which generate a random national code and a random cell number, respectively.

The randomized national code follows a specific mathematical rule suitable for generating valid Iranian national codes.

The randomized cell number uses one of the following prefixes: `["983", "984", "985", "986", "987", "988"]`.


## 🔱 Installation

To use the main utilities of this service, simply add the resource to your file:

```bash
Resource        services/backend/fresh-user-initializer-service.resource
```

You can then use the non-private keywords from this service.

The next section provides a more detailed overview of the available keywords.

## ♾️ Keywords

The following keywords are marked as **private** and should **not** be used outside this service.  
They are documented here to assist future maintainers and developers in understanding, maintaining, or extending the service.

#### Public Keywords

These are the two main, widely used keywords:

1. **Generate A Fresh User**  
   Attempts to generate a new user—**a user who has no `user_id`** in either database.  
   Retries up to the `max_retry` count if needed.  
   > Default `max_retry`: **60**

   **Returns:**  
   A dictionary `generated_user_info` with the following keys and values:  
   `{user_id: ${generated_user_id}, user_cell_number: ${generated_cell_number} , user_national_code: ${generated_national_code}}`

2. **Generate A Predefined User**  
   Given a `cell_number` and a `national_code`, evaluates their validity and consistency across **switch_credit_db** and **user_db**.

   **Returns:**  
   A dictionary `user_info` with the following keys:  
   `{user_id: ${user_id} , user_cell_number: ${cell_number} , user_national_code: ${national_code}}`

-----

#### Private Keywords

1. **Check If Cell Number Does Exist**  
   Checks both the **user_db** and **switch_credit_db**.  
   Returns `True` if the cell number exists in either database; otherwise, returns `False`.

2. **Check If National Code Does Exist**  
   Checks both the **user_db** and **switch_credit_db**.  
   Returns `True` if the national code exists in either database; otherwise, returns `False`.

3. **Generate A Fresh Cell Number**  
   Attempts to generate a cell number that does not exist in **user_db** or **switch_credit_db**, retrying up to the `max_retry` count.

4. **Generate A Fresh National Code**  
   Attempts to generate a national code that does not exist in **user_db** or **switch_credit_db**, retrying up to the `max_retry` count.

5. **Retrieve User ID From Cell Number**  
   Retrieves the `user_id` associated with the provided cell number.

6. **Update User Database by National Code**  
   Updates the **user_db** with the `user_id` based on the national code.  
   This step is required to ensure proper installment generation.  
   A user must have logged in at least once and have a valid `user_id`.  
   This keyword fails if:
   - The `user_id` does not exist.
   - The `user_id` associated with the cell number is registered under a different `national_code`.

