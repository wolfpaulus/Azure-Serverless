#!/bin/bash
# Create a serverless function app in Azure, using az cli
# More details here: https://wolfpaulus.com/azure-serverless/
# Wolf Paulus - wolf@paulus.com

GITHUB_REPO=".../..."            # GitHub repo in format "owner/repo". E.g., "wolf-edu/azure_function"
GITHUB_TOKEN="ghp_..."           # GitHub personal  access token 
RESOURCE_GRP="..."               # alphanumeric, underscore, parentheses, hyphen, period. E.g., "RG_FUNC_DEMO"
STORAGE_ACC="..."                # globally unique, lowercase alphanumeric, between 3 and 24 characters
FUNCTION_NAME="..."              # globally unique, alphanumeric characters and hyphens, cannot start or end in a hyphen, and must be less than 64 chars.
AZURE_SUB="Azure for Students"   # Azure subscription name
REGION="eastus"                  # Azure region

echo
read -p "Do you want to start the deployment process? [y/n]: " -n1 var
[ ! "$var" = y ] && echo && exit 0
echo
read -p "Do you want to login to azure? An access/refresh token gets cached for sometime. But if you have not login recently, you need to do this step. [y/n]: " -n1 var
if [ "$var" = 'y' ]; then
    az login
fi
echo

echo
echo "Step 1: === Creating a resource group: ${RESOURCE_GRP} ==="
read -p 'Do you want to execute this step? [y/n]: ' -n1 var
echo
if [ "$var" = 'y' ]; then
    az group create\
    -n "${RESOURCE_GRP}"\
    -l "${REGION}"\
    --subscription "${AZURE_SUB}"
    echo '... done.'
fi
echo

echo
echo "Step 2: === Creating a storage account: ${STORAGE_ACC} ==="
read -p 'Do you want to execute this step? [y/n]: ' -n1 var
echo
if [ "$var" = 'y' ]; then
    az storage account create\
    -n "${STORAGE_ACC}"\
    -g "${RESOURCE_GRP}"\
    -l "${REGION}"\
    --subscription "${AZURE_SUB}"
    echo '... done.'
fi
echo

#
#  Create the serverless function app.
#  To determine avail. Python runtimes, exec. `az webapp list-runtimes`
#
echo
echo "Step 3: === Creating the serverless function as ${FUNCTION_NAME} ==="
read -p 'Do you want to execute this step? [y/n]: ' -n1 var
echo
if [ "$var" = 'y' ]; then
    az functionapp create\
    -n "${FUNCTION_NAME}"\
    -g "${RESOURCE_GRP}"\
    -s "${STORAGE_ACC}"\
    -c "${REGION}"\
    --functions-version "4"\
    --https-only "true"\
    --runtime-version "3.11"\
    --runtime "python"\
    --os-type "linux"\
    --subscription "${AZURE_SUB}"
    echo '... done.'
fi
echo

echo
echo "Step 4: === Configuring the application setting for ${FUNCTION_NAME} ==="
read -p 'Do you want to execute this step? [y/n]: ' -n1 var
echo
if [ "$var" = 'y' ]; then
    az functionapp config appsettings set\
    -n "${FUNCTION_NAME}"\
    -g "${RESOURCE_GRP}"\
    --settings "AzureWebJobsFeatureFlags=EnableWorkerIndexing AzureWebJobsDisableHomepage=true"\
    --subscription "${AZURE_SUB}"
    echo '... done.'
fi
echo

echo
echo "Step 5: === Deploying the github actions for ${FUNCTION_NAME} ==="
read -p 'Do you want to execute this step? [y/n]: ' -n1 var
echo
if [ "$var" = 'y' ]; then
    az functionapp deployment github-actions add\
    --repo "${GITHUB_REPO}"\
    -b "main"\
    --build-path "."\
    -n "${FUNCTION_NAME}"\
    -g "${RESOURCE_GRP}"\
    -r "python"\
    -v "3.11"\
    --token "${GITHUB_TOKEN}"\
    --subscription "${AZURE_SUB}"
    echo '... done.'
fi
echo
