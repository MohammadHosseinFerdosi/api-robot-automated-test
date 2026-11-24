# 🪼 Cortex App

Cortex is an application that can alleviate the constant need for allocation and account closure for manual testing.

Here are our contributions and abilities of our application:

1. Allocation
    - Random user allocation
    - Specific user allocation
2. Close
    - Close all accounts by cell number
    - Close account by credit ID
    - Clean accounts by user ID (Factory reset) ⚠️

> You can add your features to the app as well ... :)

# Table of Contents

1. [Installation](#installation)
    - [Step 0: Installing Dependencies](#step-0-installing-dependencies)
    - [Step 1: Run The Application](#step-2-run-the-application)
2. [App Functionality](#app-functionality)
3. [To Close The Application](#to-close-the-application)


# Installation

Simple and Efficient in 2 steps ...

## Step 0: Installing Dependencies

Use your preferred environment and `pip install -r requirements.txt`. 

## Step 1: Run the Application

Navigate to the cortex directory and run:

```bash
cd mini_apps/cortex
python app.py
```

## Step 4: Open in Browser

Once the app is running, open your browser and go to:

```
http://localhost:8000
```

You can change the port and app settings in the `.env` file located next to `docker-compose.yml`. The 8000 is the default port.


# App Functionality

A few things to remember:

1. There is an easter egg in the application. If you find it, congratulations!
2. The Platform logo is the Home Button. Click on it when you want to return to the main panel.
3. To allocate, click on allocate and fill in your information (left is cell number, right is national code). Both are hard requirements. Click on generate to randomly generate these accounts. You can add a card and remove a card. The allocation follows the order of your cards. The backend for this process is Robot Framework.
4. To close an account, click on close and fill in your information. If the dropdown is on cell number, all of your accounts will be closed. To close a specific credit ID, set the dropdown to credit ID. In very special cases, click on clean data.
5. **DO NOT** use the clean data lightly. It resembles a factory reset procedure and should only be used in special cases when bad data is generated and you are unable to close your account via normal methods.

# To Close The Application

Simply kill or interrupt the process.

> Special thanks to Amin Oruji for publicly providing the Groovy files used to clean account data.