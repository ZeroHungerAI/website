#!/bin/bash

# following MS naming conventions 
# https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming

echo "Setting up infrastructure for ZeroHunger.ai website"
echo "First, we login and create a service principal for the website"
az login
echo "Please provide the following details:"
read -p "tenantId: " tenantId
read -p "subscriptionId: " subscriptionId
read -p "environment (qa/www): " env
location="westeurope"
resourceGroupName="rg-website-$env-$location"
echo "resourceGroupName: $resourceGroupName"
storageAccountName="stwebsite$env"
echo "storageAccountName: $storageAccountName"

read -p "Creating resource group, press enter to continue"
echo "Create Resource Group for the website and storage account"
az group create --name $resourceGroupName --location $location

# Create the service principal and capture the output
sp_credentials=$(az ad sp create-for-rbac --name "ZeroHungerWebsite" --role contributor --scopes /subscriptions/$subscriptionId/resourceGroups/$resourceGroupName --sdk-auth)

# Set the output as a GitHub secret
echo $sp_credentials | gh secret set AZURE_SERVICE_PRINCIPAL
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


echo "Create Storage Account for the website"
az storage account create --name $storageAccountName --resource-group $resourceGroupName --location $location --sku Standard_LRS
echo "Enable static website hosting"
az storage blob service-properties update --account-name $storageAccountName --static-website --404-document 404.html --index-document index.html

echo "Storage Account Name: $storageAccountName"
storageAccountKey=$(az storage account keys list --account-name $storageAccountName --resource-group $resourceGroupName --query "[0].value" --output tsv)

gh secret set AZURE_STORAGE_ACCOUNT_NAME -b"$storageAccountName"
gh secret set AZURE_STORAGE_ACCOUNT_KEY -b"$storageAccountKey"

# Create Key Vault
# az keyvault create --name websiteqakeyvault --resource-group $resourceGroupName --location $location

# Create Resource Group for DNS
# az group create --name website-dns-rg --location $location

# Setup DNS
# az network dns zone create --name website.ai --resource-group website-dns-rg
# az network dns record-set cname add-record --resource-group website-dns-rg --zone-name website.ai --record-set-name qa --cname $storageAccountName.z6.web.core.windows.net

