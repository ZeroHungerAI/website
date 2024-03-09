# zerohunger
ZeroHunger.ai Website

## requirements

Built with gohugo.io

```
brew install hugo
```
## how to set up

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
  "tenantId": "<tenant>"
}
```

```bash
cd Work/2024/website/website
gh secret set AZURE_SERVICE_PRINCIPAL -e qa
```