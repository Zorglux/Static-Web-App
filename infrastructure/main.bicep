param location string = 'global'
param appName string = 'my-web-app'
// -------------------------------------- // 
@description('Create my static web app')
resource StaticWebApp 'Microsoft.Web/staticSites@2023-12-01' = {
  name: appName
  location: location
  sku: {
    name: 'Free'
    tier: 'Free'
  }
}
// ===================================================== // 
output staticWebAppDeploymentToken string = StaticWebApp.listSecrets().properties.apiKey
