# 🪼 UI Testing with Playwright

This documentation covers the playwright installation and integration with robotframework.

## Table of Contents

1. [Installing Node.js and NPM](#installing-nodejs-and-npm)
2. [Verify Installation](#verify-installation)
3. [Setting Up Python Environment](#setting-up-python-environment)
4. [Installing Python Requirements](#installing-python-requirements)
5. [Initializing rfbrowser](#initializing-rfbrowser)
6. [Running a Hello World Test](#running-a-hello-world-test)
7. [References](#references)

---

## Installing Node.js and NPM

1. Go to the official Node.js download page: [https://nodejs.org/en/download](https://nodejs.org/en/download)
2. Download the **latest LTS version** for your operating system:

   * Windows: `.msi` installer
   * macOS: `.pkg` installer
   * Linux: follow your distro instructions
3. Run the installer and follow the on-screen instructions.

---

## Verify Installation

Open a terminal or command prompt and check the versions:

```bash
node -v
npm -v
```

If both commands return version numbers, Node.js and npm are installed successfully.

---

## Setting Up Python Environment

1. Create a virtual environment (venv) or use your preferred environment manager (like Conda):

```bash
# Using venv
python -m venv venv
# Activate on Windows
venv\Scripts\activate
# Activate on macOS/Linux
source venv/bin/activate
```

2. Once activated, you can install Python packages in an isolated environment.

---

## Installing Python Requirements

1. Install the main requirements:

```bash
pip install -r requirements.txt
```

2. Install UI testing requirements:

```bash
pip install -r requirements-UI.txt
```

> **Tip:** If you want to add another `requirements` file to the same environment, just run the `pip install -r <file>` command again. It will update the environment without affecting existing packages.

---

## Initializing rfbrowser

1. Ensure your virtual environment is activated.
2. Initialize the rfbrowser:

```bash
rfbrowser init
```

This sets up all necessary browser drivers and configurations.

---

## Running a Hello World Test

Create a test file with the following content:

```robot
*** Settings ***
Library     Browser

*** Test Cases ***
Hello World Test
    Set Browser Timeout    30s
    New Browser    chromium    headless=True
    New Context
    New Page    https://example.com
    Get Title
    Close Context
    Close Browser
```

Run the test:

```bash
robot hello_world_test.robot
```

If everything is set up correctly, the test should pass.

> **Note:** This documentation only covers installation. For details on keywords and advanced usage, refer to the official documentation and online forums.

---

## References

* [Node.js Official Documentation](https://nodejs.org/en/docs/)
* [Playwright Python Documentation](https://playwright.dev/python/)
* [Robot Framework Browser Library](https://marketsquare.github.io/robotframework-browser/Browser.html)
