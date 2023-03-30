param storageAccountName string= 'promitxstorage'
param location string='westus3'
param tier string = 'Standard_LRS'
param kind string = 'StorageV2'

resource adlsStorageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  kind: kind
  sku: {
    name: tier
  }
  
  properties: {
    accessTier: 'Hot'
    isHnsEnabled: true
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    
  }
}
