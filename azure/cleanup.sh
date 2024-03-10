#!/bin/bash
service="website"

read -p "clean up resources?"
az group delete --name rg-$service-$ENV-westus --yes
az ad sp delete --id $(az ad sp list --display-name ZeroHunger$service-$ENV --query "[].appId" -o tsv)
az storage account delete --name st$service$ENV --resource-group rg-$service-$ENV-westus --yes
az network dns record-set a delete --name $service --resource-group rg-$service-$ENV-westus --zone-name $ENV.zeroHunger.ai --yes
az network dns zone delete --name $ENV.zeroHunger.ai --resource-group rg-$service-$ENV-westus --yes
gh secret delete AZURE_SERVICE_PRINCIPAL -e"$ENV"
gh secret delete AZURE_SUBSCRIPTION_ID -e"$ENV"
gh secret delete AZURE_STORAGE_ACCOUNT_NAME -e"$ENV"
gh secret delete AZURE_STORAGE_ACCOUNT_KEY -e"$ENV"
gh secret delete AZURE_SUBDOMAIN -e"$ENV"

