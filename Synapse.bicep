@description('The Name of the Envoirnment of Resource')
param envoirnment string

@description('The Location of The Resource Group and All Other Resources')
param location string='westeurope'

@description('The name of the Subnet')
param subnetID string

@description('The Subnet ID of Mgmt Subnet')
param subnet2ID string

@description('The Object ID of Vnet')
param VnetId string


var synapsename=toLower('promitx-syn-edm-${envoirnment}-${location}')
var datalakename =toLower('promitxedm${envoirnment}001')
var blobname1 ='dledm'
var blobname2 ='externaldata'




resource datalakestore 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: datalakename
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
    
  }
  properties:{
    
    
    accessTier: 'Hot'
    isHnsEnabled: true

  }
}
resource blobservice 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01'={
  parent:datalakestore
  name:'default'

}
resource filesystem 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01'={
  parent:blobservice
  name:blobname1
}

resource filesystem2 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01'={
  parent:blobservice
  name:blobname2
}

resource azsynapse 'Microsoft.Synapse/workspaces@2021-06-01'={
  dependsOn:[
    datalakestore
  ]
  location:location
  name:synapsename
  identity:{
    type:'SystemAssigned'
  }
  properties:{
    defaultDataLakeStorage:{
      resourceId:datalakestore.id
      accountUrl:'https://${datalakename}.dfs.core.windows.net'
      filesystem:blobname1
    }
    managedVirtualNetwork:'default'
    publicNetworkAccess:'Enabled'
  }
}



