#!/bin/bash

RESOURCE_GRP="RG_FUNC_APP"     # alphanumeric, underscore, parentheses, hyphen, period
STORAGE_ACC="safuncapp0043"    # globally unique, lowercase alphanumeric, between 3 and 24 characters
REGION="eastus"                # to list possible locations, exec. `az account list-locations` 
FUNCTION_NAME="func0043"       # globally unique, alphanumeric characters and hyphens, cannot start or end in a hyphen, and must be less than 64 chars.
AZURE_SUB="Azure for Students" # subscription name or id
GITHUB_REPO="wolf-edu/az_py_func"  # GitHub repo in format "owner/repo"
GITHUB_TOKEN="ghp_..."         # GitHub personal access token

az login

az group create\
 -n "${RESOURCE_GRP}"\
 -l "${REGION}"\
 --subscription "${AZURE_SUB}"

az storage account create\
 -n "${STORAGE_ACC}"\
 -g "${RESOURCE_GRP}"\
 -l "${REGION}"\
 --subscription "${AZURE_SUB}" 

az functionapp create\
 -n "${FUNCTION_NAME}"\
 -g "${RESOURCE_GRP}"\
 -s "${STORAGE_ACC}"\
 -c "${REGION}"\
 --functions-version "4"\
 --https-only "true"\
 --os-type "Linux"\
 --runtime "python"\
 --runtime-version "3.10"\   
 --subscription "${AZURE_SUB}"  # to determine avail. Python runtimes, exec. `az webapp list-runtimes`

az functionapp config appsettings set\
 -n "${FUNCTION_NAME}"\
 -g "${RESOURCE_GRP}"\
 --settings "AzureWebJobsFeatureFlags=EnableWorkerIndexing"\
 --subscription "${AZURE_SUB}"

az functionapp deployment github-actions add\
 --repo "${GITHUB_REPO}"\
 -b "main"\
 --build-path "."\
 -n "${FUNCTION_NAME}"\
 -g "${RESOURCE_GRP}"\
 -r "python"\
 -v "3.10"\
 --token "${GITHUB_TOKEN}"\
 --subscription "${AZURE_SUB}"
