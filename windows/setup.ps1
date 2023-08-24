# Create a serverless function app in Azure, using az cli
# More details here: https://wolfpaulus.com/azure-serverless/
# Wolf Paulus - wolf@paulus.com

$GITHUB_REPO=".../..."            # GitHub repo in format "owner/repo". E.g., "wolf-edu/azure_function"
$GITHUB_TOKEN="ghp_..."           # GitHub personal access token 
$RESOURCE_GRP="..."               # alphanumeric, underscore, parentheses, hyphen, period. E.g., "RG_FUNC_DEMO"
$STORAGE_ACC="..."                # globally unique, lowercase alphanumeric, between 3 and 24 characters
$FUNCTION_NAME="..."              # globally unique, alphanumeric characters and hyphens, cannot start or end in a hyphen, and must be less than 64 chars.
$AZURE_SUB="Azure for Students"   # Azure subscription name
$REGION="eastus"                  # Azure region

$var = &{(Read-Host "Do you want to start the deployment process? [y/n]") -as [char]}
if ($var -ne "y") {
    exit
}     

$var = &{(Read-Host "Do you want to login to azure? An access/refresh token gets cached for sometime. But if you have not login recently, you need to do this step. [y/n]") -as [char]}
if ($var -eq "y") {
    az login
}  

Write-Host "Step 1: === Creating a resource group: $RESOURCE_GRP ==="
$var = &{(Read-Host "Do you want to execute this step? [y/n]") -as [char]}
if ($var -eq "y") {
    az group create `
    -n $RESOURCE_GRP `
    -l $REGION `
    --subscription $AZURE_SUB
    Write-Host "... done."
}

Write-Host "Step 2: === Creating a storage account: $STORAGE_ACC ==="
$var = &{(Read-Host "Do you want to execute this step? [y/n]") -as [char]}
if ($var -eq "y") {
    az storage account create `
    -n $STORAGE_ACC `
    -g $RESOURCE_GRP `
    -l $REGION `
    --subscription $AZURE_SUB
    Write-Host "... done."
}

Write-Host "Step 3: === Creating the serverless function as $FUNCTION_NAME ==="
$var = &{(Read-Host "Do you want to execute this step? [y/n]") -as [char]}
if ($var -eq "y") {
    az functionapp create `
    -n $FUNCTION_NAME `
    -g $RESOURCE_GRP `
    -s $STORAGE_ACC `
    -c $REGION `
    --functions-version "4" `
    --https-only "true" `
    --runtime-version "3.10" `
    --runtime "python" `
    --os-type "Linux" `
    --subscription $AZURE_SUB
    Write-Host "... done."
}

Write-Host "Step 4: === Configuring the application setting for $FUNCTION_NAME ==="
$var = &{(Read-Host "Do you want to execute this step? [y/n]") -as [char]}
if ($var -eq "y") {
    az functionapp config appsettings set `
    -n $FUNCTION_NAME `
    -g $RESOURCE_GRP `
    --settings "AzureWebJobsFeatureFlags=EnableWorkerIndexing" `
    --subscription $AZURE_SUB
    Write-Host "... done."
}

Write-Host "Step 5: === Deploying the github actions for $FUNCTION_NAME ==="
$var = &{(Read-Host "Do you want to execute this step? [y/n]") -as [char]}
if ($var -eq "y") {
az functionapp deployment github-actions add `
    --repo $GITHUB_REPO `
    -b "main" `
    --build-path "." `
    -n $FUNCTION_NAME `
    -g $RESOURCE_GRP `
    -r "python" `
    -v "3.11" `
    --token $GITHUB_TOKEN `
    --subscription $AZURE_SUB
    Write-Host "... done."
}    