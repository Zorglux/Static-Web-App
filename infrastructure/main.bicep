param location string = 'eastus2'
param appName string = 'my-static-app'

resource staticSite 'Microsoft.Web/staticSites@2023-12-01' = {
  name: appName
  location: location
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    provider: 'GitHub'
  }
}

output staticWebAppDefaultHostName string = staticSite.properties.defaultHostname
output deploymentToken string = staticSite.listSecrets().properties.apiKey
