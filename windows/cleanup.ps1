# Delete the serverless function app in Azure, using az cli
# Find more details here: https://wolfpaulus.com/azure-serverless/
# Wolf Paulus - wolf@paulus.com

$RESOURCE_GRP="..."             # alphanumeric, underscore, parentheses, hyphen, period
$AZURE_SUB="Azure for Students" # subscription name or id

Write-Host "Delete the Resource Group and all its resosurces, this will take a few minutes."
$var = &{(Read-Host "Do you want to start the removal process? [y/n]") -as [char]}
if ($var -ne "y") {
    exit
}   

$var = &{(Read-Host "Do you want to login to azure? An access/refresh token gets cached for sometime. But if you have not login recently, you need to do this step. [y/n]") -as [char]}
if ($var -eq "y") {
    az login
} 
az group delete -n $RESOURCE_GRP --subscription $AZURE_SUB
