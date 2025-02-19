param subscription string
param resource_group string
param location string
param storageAccount_name string
param queue_name string

var queue_api_name = 'azurequeues'

resource my_StorageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccount_name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  identity: {
    type: 'None'
  }
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    isNfsV3Enabled: false
    isLocalUserEnabled: true
    isSftpEnabled: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    isHnsEnabled: false
    networkAcls: {
      resourceAccessRules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

/*
resource storageAccounts_mysa8lxzl5hehmyjw_name_default 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: my_StorageAccount
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_mysa8lxzl5hehmyjw_name_default 'Microsoft.Storage/storageAccounts/fileServices@2023-05-01' = {
  parent: my_StorageAccount
  name: 'default'
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}
*/

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_mysa8lxzl5hehmyjw_name_default 'Microsoft.Storage/storageAccounts/queueServices@2023-05-01' = {
  parent: my_StorageAccount
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

/*
resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_mysa8lxzl5hehmyjw_name_default 'Microsoft.Storage/storageAccounts/tableServices@2023-05-01' = {
  parent: my_StorageAccount
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}
*/

resource storageAccounts_mysa8lxzl5hehmyjw_name_default_testqueue 'Microsoft.Storage/storageAccounts/queueServices/queues@2023-05-01' = {
  parent: Microsoft_Storage_storageAccounts_queueServices_storageAccounts_mysa8lxzl5hehmyjw_name_default
  name: queue_name
  properties: {
    metadata: {}
  }
/*
    dependsOn: [
    my_StorageAccount
  ]
*/
}

resource myQueueConnection 'Microsoft.Web/connections@2016-06-01' = {
  name: '${queue_name}Connection'
  location: location
//  kind: 'V1'
  properties: {
    displayName: 'Azure Queue Connection'
    customParameterValues: {}
    parameterValues: {
      storageaccount: my_StorageAccount.name
      sharedkey: my_StorageAccount.listkeys().keys[0].value
      }
    api: {
      name: '${queue_name}QueueConnection'
      displayName: 'Azure Queues'
      description: 'Azure Queue storage provides cloud messaging between application components. Queue storage also supports managing asynchronous tasks and building process work flows.'
      iconUri: 'https://conn-afd-prod-endpoint-bmc9bqahasf3grgk.b01.azurefd.net/releases/v1.0.1725/1.0.1725.4008/${queue_api_name}/icon.png'
      brandColor: '#0072C6'
      id: subscriptionResourceId('Microsoft.Web/locations/managedApis', location, queue_api_name)
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: 'https://${environment().resourceManager}:443/subscriptions/${subscription}/resourceGroups/${resource_group}/providers/Microsoft.Web/connections/${queue_api_name}/extensions/proxy/testConnection?api-version=2016-06-01'
        method: 'get'
      }
    ]
  }
}

output queueConnection_id string = myQueueConnection.id
