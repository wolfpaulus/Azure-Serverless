#!/bin/bash
# Delete the serverless function app in Azure, using az cli
# Find more details here: https://wolfpaulus.com/azure-serverless/
# Wolf Paulus - wolf@paulus.com

RESOURCE_GRP="..."               # alphanumeric, underscore, parentheses, hyphen, period. E.g., "RG_FUNC_DEMO"
AZURE_SUB="Azure for Students"   # Azure subscription name

echo
read -p "Do you want to start the removal process? [y/n]: " -n1 var
[ ! "$var" = y ] && echo && exit 0
echo
read -p "Do you want to login to azure? An access/refresh token gets cached for sometime. But if you have not login recently, you need to do this step. [y/n]: " -n1 var
if [ "$var" = 'y' ]; then
    az login
fi
echo

# Delete the Resource Group and all its resosurces, this will take a few minutes
az group delete -n "${RESOURCE_GRP}" --subscription "${AZURE_SUB}"
