param location string = 'eastus2'
param appName string = 'my-static-app'
// ============================== // 
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
// ================ // 
resource CosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' = {
  name: 'database-account-static-app'
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    capacity:{ totalThroughputLimit: 1000 }
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
    locations:[
      { locationName: location
      failoverPriority: 0
      }
    ]
  }
}


resource Database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-05-15' = {
  parent: CosmosAccount
  name: 'database-static-app'
  properties: {
      resource: {
      id: 'database-static-app'
    }
  }
}


resource Container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
 parent: Database
  name: 'Counter'
  properties: {
    resource: {
      id: 'Counter'
      partitionKey: {
        paths: [
          '/id'
        ]
        kind: 'Hash'
      }
    }
  }
}
