#!/bin/bash

# Variables
RESOURCE_GROUP="NG-FILE-SERVICE-REVIEW-000"   # Resource group containing the Storage Account
TEMPLATE_FILE="ng-file-service-sa-template.json"                  # Template file path for the storage account
PARAMETERS_FILE="ng-file-service-sa-parameters.json"             # Parameters file path for the storage account
PRIVATE_ENDPOINT_TEMPLATE_FILE="ng-file-service-pep-template.json" # Template file path for the private endpoint
PRIVATE_ENDPOINT_PARAMETERS_FILE="ng-file-service-pep-parameters.json" # Parameters file path for the private endpoint
SUBSCRIPTION_ID="e468025a-9923-4e46-977e-344fba9b2040"  # Your subscription ID

# Set the correct Azure subscription
az account set --subscription $SUBSCRIPTION_ID

# Deploy the Storage Account first
echo "Deploying Storage Account..."
az deployment group create \
  --name StorageDeployment \
  --resource-group $RESOURCE_GROUP \
  --template-file $TEMPLATE_FILE \
  --parameters @$PARAMETERS_FILE

# Wait for storage account deployment to finish (optional, but recommended for sequencing)
echo "Waiting for Storage Account deployment to complete..."
sleep 10

# Deploy the Private Endpoint (after storage account is deployed)
echo "Deploying Private Endpoint..."
az deployment group create \
  --name PrivateEndpointDeployment \
  --resource-group $RESOURCE_GROUP \
  --template-file $PRIVATE_ENDPOINT_TEMPLATE_FILE \
  --parameters @$PRIVATE_ENDPOINT_PARAMETERS_FILE \
  --verbose

# Output success message
echo "Storage Account and Private Endpoint deployed successfully!"
