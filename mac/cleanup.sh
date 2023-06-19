#!/bin/bash

RESOURCE_GRP="RG_FUNC_APP"     # alphanumeric, underscore, parentheses, hyphen, period
AZURE_SUB="Azure for Students" # subscription name or id

# Delete the Resource Group and all its resosurces, this will take a few minutes
az group delete -n $RESOURCE_GRP --subscription $AZURE_SUB

