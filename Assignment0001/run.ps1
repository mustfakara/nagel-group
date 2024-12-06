# Default subscription and resource group
$subscriptionId = "SUBID12345"
$resourceGroupName = "NG-RESOURCEGROUP-NAME" 

# Input parameters
$storageAccountName = Read-Host -Prompt "Enter Storage Account Name (lowercase and numbers allowed. Start with 'ng')"

# Redundancy options
$allowedOptions = @("Standard_LRS", "Standard_GRS", "Standard_ZRS", "Premium_LRS", "Premium_ZRS",)

# Redundancy option input with validation
do {
    Write-Output "Available Redundancy Options: $($allowedOptions -join ', ')"
    $redundancyOption = Read-Host -Prompt @"
    Enter Redundancy Option:

    LRS: Locally-redundant storage - 3 copies in the same data center, low protection level, low cost.
    ZRS: Zone-Redundant Storage - 3 copies in different zones in the same region, high protection, medium-high cost.
    GRS: Geo-redundant storage - 3 copies in the primary region and 3 in the secondary region (total 6 copies), medium protection level, medium cost.
"@  

    if (-not ($redundancyOption -in $allowedOptions)) {
        Write-Output "Invalid redundancy option. Please try again."
    }
} while (-not ($redundancyOption -in $allowedOptions))

try {
    # Log in to Azure and set the subscription
    Write-Output "Logging in to Azure..."
    az login
    az account set --subscription $subscriptionId

    # Deploy the storage account
    Write-Output "Deploying storage account..."
    $result = az deployment group create `
        --resource-group $resourceGroupName `
        --template-file deployment.json `
        --parameters `
        storageAccountName=$storageAccountName `
        location=germanywestcentral `
        accountType=$redundancyOption `
        kind=StorageV2 `
        minimumTlsVersion=TLS1_2 `
        supportsHttpsTrafficOnly=true `
        allowBlobPublicAccess=false `
        accessTier=Hot `
        networkAclsDefaultAction=Allow `
        isShareSoftDeleteEnabled=false

    # Check if deployment was successful
    if ($LASTEXITCODE -eq 0) {
        Write-Output "Deployment completed successfully!"
    } else {
        Write-Output "Deployment failed with errors."
    }
}
catch {
    Write-Output "An error occurred during deployment:"
    Write-Output $_.Exception.Message
}
