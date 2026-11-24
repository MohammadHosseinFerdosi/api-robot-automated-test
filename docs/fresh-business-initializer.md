# 🪼 Business Initializer Service

This document provides detailed information about the `fresh-business-initializer-service.resource` service.

This service is used to generate a fresh user and returns a dictionary containing the `business_info`. A fresh business is defined as a business who does have a unique `business_id`.

## Table of Contents

1. [Introduction](#🔰-Introduction)
1. [Installation](#🔱-Installation)
2. [Keywords](#♾️-Keywords)

## 🔰 Introduction

The service uses the utilities provided by the `library/faker_utils.py`. This library includes the main functions used to generate a random UUID.

The randomization uses a set of randomized objects to create a more random like UUID.


## 🔱 Installation

To use the main utilities of this service, simply add the resource to your file:

```bash
Resource        services/backend/fresh-business-initializer-service.resource
```

You can then use the non-private keywords from this service.

The next section provides a more detailed overview of the available keywords.

## ♾️ Keywords

The following keywords are marked as **private** and should **not** be used outside this service.  
They are documented here to assist future maintainers and developers in understanding, maintaining, or extending the service.

#### Public Keywords

These are the two main, widely used keywords:

1. **Generate A Fresh Business**  
   Attempts to generate a new business—**a business who has unique `business_id`** .  
   Retries up to the `max_retry` count if needed.  
   > Default `max_retry`: **60**

   **Returns:**  
   A dictionary `generated_user_info` with the following keys and values:  
   `business_id=${response['business_id']}, business_name=${name}, user_name=${username}, password=${password}`

Before generation, the business is submitted to the appropriate databases via the `POST Admin Businesses` API call.

-----

#### Private Keywords

1. **Generate A Fake Business**  
   Returns a randomized business config `${username}    ${name}    ${password}`