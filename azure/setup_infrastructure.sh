#!/bin/bash

# following MS naming conventions 
# https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming

echo "Setting up infrastructure for ZeroHunger.ai website"
echo "First, we login and create a service principal for the website"
az login
echo "Please provide the following details:"
# Check if tenantId is set
if [ -z "$tenantId" ]; then
    read -p "Enter your tenantId:" tenantId
fi
# Check if subscriptionId is set
if [ -z "$subscriptionId" ]; then
    read -p "Enter your subscriptionId:" subscriptionId
fi
# Check if environment is set
if [ -z "$environment" ]; then
    read -p "environment (qa/www): " environment
fi

location="westeurope"
resourceGroupName="rg-website-$environment-$location"
echo "resourceGroupName: $resourceGroupName"
storageAccountName="stwebsite$environment"
echo "storageAccountName: $storageAccountName"

#read -p "Creating resource group, press enter to continue"
echo "Create Resource Group for the website and storage account"
az group create --name $resourceGroupName --location $location

# Create the service principal and capture the output
sp_credentials=$(az ad sp create-for-rbac --name "ZeroHungerWebsite" --role contributor --scopes /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName --sdk-auth)

# Transform the output
transformed_credentials=$(echo $sp_credentials | jq '{clientId: .appId, clientSecret: .password, tenantId: .tenant, subscriptionId: .subscriptionId}')

# Set the transformed output as a GitHub secret
echo $transformed_credentials | gh secret set AZURE_SERVICE_PRINCIPAL -e"$environment"
# {
#   "clientId": "<appId>",
#   "clientSecret": "<password>",
#   "tenantId": "<tenant>",
#   "subscriptionId": "<subscriptionId>"
# }
# read -p "clientId: " clientId
# read -p "clientSecret: " clientSecret

# az ad sp create-for-rbac
# 
# echo "Role assignments for the service principal"
# az role assignment create --assignee $clientId --role "Contributor" --scope /subscriptions/$subscriptionId
# az role assignment create --assignee $clientId --role "DNS Zone Contributor" --scope /subscriptions/$subscriptionId


# Log in as the service principal
az login --service-principal --username $clientId --password $clientSecret --tenant $tenantId

# Create the storage account
az storage account create --name $storageAccountName --resource-group $resourceGroupName --location $location --sku Standard_LRS --auth-mode login

# Enable static website hosting
az storage blob service-properties update --account-name $storageAccountName --static-website --404-document 404.html --index-document index.html --auth-mode login

echo "Storage Account Name: $storageAccountName"
storageAccountKey=$(az storage account keys list --account-name $storageAccountName --resource-group $resourceGroupName --query "[0].value" --output tsv)

gh secret set AZURE_STORAGE_ACCOUNT_NAME -b"$storageAccountName" -e"$environment"
gh secret set AZURE_SUBSCRIPTION_ID -b"$subscriptionId" -e"$environment
#gh secret set AZURE_STORAGE_ACCOUNT_KEY -b"$storageAccountKey"

# Create Key Vault
# az keyvault create --name websiteqakeyvault --resource-group $resourceGroupName --location $location

# Create Resource Group for DNS
# az group create --name website-dns-rg --location $location

# Setup DNS
# az network dns zone create --name website.ai --resource-group website-dns-rg
# az network dns record-set cname add-record --resource-group website-dns-rg --zone-name website.ai --record-set-name qa --cname $storageAccountName.z6.web.core.windows.net

