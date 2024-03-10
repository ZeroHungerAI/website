#!/bin/bash
service="website"

#set -x

# Check if already logged in
if ! az account show > /dev/null 2>&1; then
    echo "Please log in to Azure:"
    az login
fi
az login # fix service principal login
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
sp_credentials=$(az ad sp create-for-rbac --name "ZeroHunger$service-$environment" --role contributor --scopes /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName)

# Add subscriptionId to sp_credentials
sp_credentials=$(echo $sp_credentials | jq --arg subscriptionId "$subscriptionId" '. + {subscriptionId: $subscriptionId}')

# Transform the credentials
transformed_credentials=$(echo $sp_credentials | jq '{clientId: .appId, clientSecret: .password, tenantId: .tenant, subscriptionId: .subscriptionId}')

echo $transformed_credentials

# Set the transformed output as a GitHub secret
echo $transformed_credentials | gh secret set AZURE_SERVICE_PRINCIPAL -e"$environment"
gh secret set AZURE_SUBSCRIPTION_ID -b"$subscriptionId" -e"$environment"
gh secret set AZURE_STORAGE_ACCOUNT_NAME -b"$storageAccountName" -e"$environment"
gh secret set AZURE_RESOURCE_GROUP -b"$resourceGroupName" -e"$environment"
gh secret set AZURE_LOCATION -b"$location" -e"$environment"
#gh secret set AZURE_STORAGE_ACCOUNT_KEY
#gh secret set AZURE_TENANT_ID -b"$tenantId" -e"$environment"
#gh secret set AZURE_CLIENT_ID -b"$(echo $sp_credentials | jq -r '.appId')" -e"$environment"
#gh secret set AZURE_CLIENT_SECRET -b"$(echo $sp_credentials | jq -r '.password')" -e"$environment"

# Run az_dns_setup.sh
# chmod +x ./az_dns_setup.sh
# ./az_dns_setup.sh

# Azure login
# user=$(echo $sp_credentials | jq -r '.appId')
# password=$(echo $sp_credentials | jq -r '.password')
# az login --service-principal -u "$user" -p "$password" --tenant "$tenantId"

# # Create storage account and setup for static website hosting
# az storage account create --name $storageAccountName --resource-group $resourceGroupName --location $location --sku Standard_LRS --auth-mode login
# az storage blob service-properties update --account-name $storageAccountName --static-website --404-document 404.html --index-document index.html --auth-mode login

# Create Key Vault
#az keyvault create --name zerohungerqakeyvault --resource-group zerohunger-qa-rg --location eastus

# Setup DNS
#az network dns zone create --name zerohunger.ai --resource-group zerohunger-qa-rg
#az network dns record-set cname add-record --resource-group zerohunger-qa-rg --zone-name zerohunger.ai --record-set-name qa --cname zerohungerqastorage.z6.web.core.windows.net

