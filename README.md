# Azure Serverless with a touch of TDD and CI/CD
Read the complete documentation of this project here: https://wolfpaulus.com/azure-serverless/


# Azure Serverless Functions in Python
Let's build an Azure Function. Something beyond "Hello World" but still simple enough, like a web service that tells if a given number k is a prime number and can also produce a list of the 1st *n* prime numbers. To make this easily repeatable and scriptable, let's favor the command line and command line tools, when possible.

Let’s take a closer look at the repository:

## .github/workflows

GitHub Actions is a continuous integration and continuous delivery (CI/CD) platform that allows you to automate your build, test, and deployment pipeline. GitHub provides Linux, Windows, and macOS virtual machines to run workflows.
The main_tests.yml workflow is triggered to run on push and pull_request events. It checks out the code, installs the dependencies declared in the requirements.txt file, and runs all tests in the ./tests directory.
The main_<funcname>.yml workflow runs after main_tests workflow completed (without errors).
It checks out the code, deploys the specified Python version, installs the dependencies, and deploys (only) the files in the ./src directory.

## .venv

Virtual Environaments (venv) allow separate package installations for different projects. Using the command line a venv is created like so:
python3 -m venv ./.venv
A virtual environment needs to be “activated” using a script in its binary directory (mac: ./.venv/bin/activate Windows PS C:\> .\.venv\Scripts\Activate.ps1).
Using VSCode, open the command panel (press F1), look for “>Python: Create Environment”, and select Venv. Right there, you can also already install the dependencies.

## .vscode

The vscode directory contains recommendations for extensions (extensions.json), the debugger configuration (launch.json), settings for automatically activating the venv, and unit-test settings.

mac and windows

These directories contain scripts to create and delete Azure resources.

## src

The source directory contains the files that will be deployed into Azure. This folder also contains the host.json file, containing configuration options that affect all functions in a function app.

tests

The tests directory contains the pytest unit tests. All here defined tests will run on GitHub, and only if all tests pass will the next workflow be triggered. Before committing source-code, test can and should be run locally. Run tests in an already activated environment like so:

pytest


## ./

The .gitignore file contains file-path and file name patterns that git you ignore and pytest.ini contains informtation where pytest should look for source and test code.