param functionAppName string
param storageAccountName string
param location string
param hostingPlanName string
param kvName string

resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  kind: 'functionapp'
  location: location
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference('microsoft.insights/components/${functionAppName}', '2015-05-01').InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: reference('microsoft.insights/components/${functionAppName}', '2015-05-01').ConnectionString
        }
        {
          name: 'databaseConnectionString'
          value: '@Microsoft.KeyVault(VaultName=${kvName};SecretName=databaseConnectionString)'
        }
      ]
    }
    serverFarmId: hostingPlan.id
    clientAffinityEnabled: false
  }
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    applicationInsights
  ]
}

resource hostingPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: hostingPlanName
  location: location
  kind: ''
  properties: {}
  sku: {
    tier: 'Dynamic'
    name: 'Y1'
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource applicationInsights 'microsoft.insights/components@2020-02-02-preview' = {
  name: functionAppName
  location: location
  tags: {}
  kind: 'web'
  properties: {
    Request_Source: 'IbizaWebAppExtensionCreate'
    Flow_Type: 'Redfield'
    Application_Type: 'web'
  }
  dependsOn: []
}

output functionIdentity string = functionApp.identity.principalId
