#!/bin/bash
service="website"

# Check if already logged in
if ! az account show > /dev/null 2>&1; then
    echo "Please log in to Azure:"
    az login
fi

# Check if ENV is set
if [ -z "$environment" ]; then
    echo "Enter your environment (subdomain) for $service:"
    read environment
fi

# Set tenantId, subscriptionId, and environment
tenantId=$(az account show --query tenantId --output tsv)
subscriptionId=$(az account show --query id --output tsv)

location="westeurope"
resourceGroupName="rg-$service-$environment-$location"
echo "resourceGroupName: $resourceGroupName"
storageAccountName="st$service$environment"
echo "storageAccountName: $storageAccountName"

# Create resource group
az group create --name $resourceGroupName --location $location

# Create service principal
sp_credentials=$(az ad sp create-for-rbac --name "ZeroHunger$service-$environment" --role contributor --scopes /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName --sdk-auth)

# Ensure sp_credentials is a valid JSON string with all necessary fields
sp_credentials='{"appId": "your-app-id", "password": "your-password", "tenant": "your-tenant", "subscriptionId": "your-subscription-id"}'

# Transform the credentials
transformed_credentials=$(echo $sp_credentials | jq '{clientId: .appId, clientSecret: .password, tenantId: .tenant, subscriptionId: .subscriptionId}')

# Now you can use transformed_credentials for Azure login
# TODO: Check if bug 1 in setup.sh is fixed
# Fix the transformation of credentials. The Azure login is failing because not all parameters are provided in 'creds'.
# Check the transformation at line 27:
# transformed_credentials=$(echo $sp_credentials | jq '{clientId: .appId, clientSecret: .password, tenantId: .tenant, subscriptionId: .subscriptionId}')

# Set the transformed output as a GitHub secret
echo $transformed_credentials | gh secret set AZURE_SERVICE_PRINCIPAL -e"$environment"
gh secret set AZURE_SUBSCRIPTION_ID -b"$subscriptionId" -e"$environment"
gh secret set AZURE_STORAGE_ACCOUNT_NAME -b"$storageAccountName" -e"$environment"
# Run az_dns_setup.sh
./az_dns_setup.sh