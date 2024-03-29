# www.zerohunger.ai

ZeroHunger.ai Website

![[Pasted image 20240328172338.png]]

## Change the website

The website is deployed via GitHub Actions to the Azure rg-website-qa-westeurope.

TODOs: 

- [ ] prod deployment
- [ ] Tests?
- [ ] DNS
- [ ] Ops Manual


### How to change the website

1. make changes
2. commit all
3. tag
4. push with tags

## requirements

Built with gohugo.io

```
brew install hugo
```
## setup local development environment

```
git clone git@github.com:mmatiaschek/zerohunger.git
cd zerohunger/ZeroHunger.ai/
git submodule update --init --recursive
hugo server -w -v
```

## Azure Deployement

prerequisites: gh and az authenticated
Set up Service principle

```bash
az ad sp create-for-rbac
```
TODO role


```json
{
  "clientId": "<appId>",
  "clientSecret": "<password>",
  "tenantId": "<tenant>",
  "subscriptionId": "<subscriptionId>"
}
```

```bash
cd Work/2024/website/website
gh secret set AZURE_SERVICE_PRINCIPAL -e qa
```