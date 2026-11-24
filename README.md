# 🤖 Api Robot Automated Test

This project contains automated tests for the PLATFORM APIs using Robot Framework.

## 🕵️ Getting Started

### 🗿 Prerequisites

Before running the tests, make sure you have the following installed and configured:

- **Python 3.8+**  
  _(Note: Python 12 or higher is NOT supported )._
- **Environment Management**: Use `.venv` or `conda` for managing Python environments.
- **IDE Recommendation**: [VS Code](https://code.visualstudio.com/) with the **RobotCode** plugin for optimal development and execution experience.


### 💿 Installing

1. Clone the repository:

```
git clone https://example.com/test/api-robot-automated-test.git
```

2. Install the dependencies:

```
pip install -r requirements.txt
```

### 🚀 Running the Tests

Run the tests using the following commands:

Standard Mode:
```
robot features/
```

Parallel Mode: (Using pabot)

```
pabot --processes 4 features/
```

- The number of processes is determined by your CPU cores (2 processes per core by default).
- If the --processes option is omitted, the default number of processes will be used.

Pro Tip: Use the RobotCode plugin in VS Code for an effortless test execution experience. 😏

## 🏭 Built With

The following libraries and tools are used in this project:

[Robot Framework](https://robotframework.org/) - Core test automation framework.

[robotframework-requests](https://github.com/MarketSquare/robotframework-requests) - HTTP library for API testing.

[robotframework-SeleniumLibrary](https://github.com/robotframework/SeleniumLibrary) - Web testing library.

[robotframework-jsonlibrary](https://github.com/nottyo/robotframework-jsonlibrary) - JSON parsing and validation.

[PyYAML](https://pyyaml.org/) - Used to inject variables from YAML files.

[Pabot](https://pabot.org/) - Enables running tests in parallel for faster execution.

## 🤝 Contributing

🙏 🙌 Thank you for your interest in contributing to Robot Framework! Here are some guidelines to help you get started.

### 👨‍💻 Contibuting with GitHub Flow Branching Model

1. Clone the Robot Framework project repository to your local machine using the Git command `git clone <repository_url>`.
2. Create a new branch for your changes using a descriptive name that conveys the purpose of the changes using the Git command `git checkout -b <branch_name>`.
3. Make your changes to the code or documentation.
4. Write tests for your changes, especially if you're adding new functionality or modifying existing functionality.
5. Push your changes to the remote repository using the Git command `git push origin <branch_name>`.
> **You can usnig Gitlens plugin in vscode insted git commands**

### 🐱‍🚀 Submitting a Merge Request

1. Create a Merge Request (MR) in the GitLab repository.
1. Provide a clear description of the changes made and their importance.
1. Collaborate with maintainers for reviews and necessary refinements.
1. Upon approval, your changes will be merged into the main branch.

### 👨‍🏫 Variable Naming Convention

When contributing to Robot Framework, it's important to follow a consistent naming convention for variables to make your code more readable and maintainable. Here are some guidelines to follow:

- Use lowercase letters for variable names.
- Separate words with underscores (`_`) for readability
- Use descriptive names that convey the purpose of the variable
- Use all capital letters for constant variables that should not be modified(constant, suite level, test level and imported test data variables)

Here are some examples:

```
${first_name}          # A variable that stores a person's first name
${last_name}           # A variable that stores a person's last name
${full_name}           # A variable that stores the concatenation of first and last names
${email_address}       # A variable that stores a person's email address
${MAX_RETRIES}         # A constant variable that defines the maximum number of retries
```

### 🤦‍♀️ 📢 NOTE: About Name Insensitivity

One important aspect of Robot Framework to keep in mind is that it is **name insensitive**. This means that keywords, variables, and other identifiers are not case-sensitive. For example, the following lines of code are equivalent:

```
${my_variable}=    Set Variable    Hello, world!
${My_Variable}=    Set Variable    Hello, world!
${MY_VARIABLE}=    Set Variable    Hello, world!
${myVariable}=     Set Variable    Hello, world!
${my variable}=    Set Variable    Hello, world!
```

In all cases, the variable `${my_variable}` will be set to the value "Hello, world!". This can be a helpful feature for making code more readable and reducing errors related to case sensitivity.

However, it's important to keep in mind that name insensitivity applies only to identifiers within Robot Framework. In some cases, external systems or libraries may be case-sensitive, so it's important to be aware of these differences when integrating with other tools.

By keeping this feature in mind and using it appropriately, you can write more readable and maintainable code in Robot Framework.

## 🧧 License

This project is licensed under the BSD 2-Clause License - see the [LICENSE.md](LICENSE.md) file for details.


## 🛠 Additional Notes
- 📖 Documentation: For more information about Robot Framework and its features, refer to the official documentation.
- 🧪 Test Coverage: Make sure new functionality is covered with appropriate test cases.
- 🤝 Collaboration: We value collaboration and constructive feedback to improve this project continually.
