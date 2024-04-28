param location string = resourceGroup().location
param kvName string
param functionAppName string
param functionAppHostingPlanName string
param storageAccountName string
param frontEndName string
param frontEndHostingPlanName string

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: frontEndHostingPlanName
  location: location
  sku: {
    name: 'F1'
  }
  kind: 'windows'
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: frontEndName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'testFunctionUrl'
          value: '@Microsoft.KeyVault(VaultName=${kvName};SecretName=testFunctionUrl)'
        }
      ]
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: kvName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: false
    accessPolicies: [
      {
        objectId: azureFunction.outputs.functionIdentity
        permissions: {
          secrets: [
            'all'
          ]
        }
        tenantId: subscription().tenantId
      }
      {
        objectId: appService.identity.principalId
        permissions: {
          secrets: [
            'all'
          ]
        }
        tenantId: subscription().tenantId
      }
    ]
  }
}

module azureFunction 'azure-function-module.bicep' = {
  name: 'azureFunction'
  params: {
    location: location
    functionAppName: functionAppName
    hostingPlanName: functionAppHostingPlanName
    storageAccountName: storageAccountName
    kvName: kvName
  }
}
