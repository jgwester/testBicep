param subscription string
param resource_group string
param location string
param storageAccount_name string
param queue_name string

module Storage './modules/storage/storage.bicep' = {
  name: 'storageDeploy'
  params: {
    subscription: subscription
    resource_group: resource_group
    location: location
    storageAccount_name: storageAccount_name
    queue_name: queue_name
  }
}

module Connection './modules/logicapp/connections.bicep' = {
  name: 'connectionDeploy'
  params: {
    subscription: subscription
    resource_group: resource_group
    location: location
  }
}

module LogicApp './modules/logicapp/triggerapp.bicep' = {
  name: 'logicAppDeploy'
  params: {
    subscription: subscription
    location: location
    storageAccount_name: storageAccount_name
    storageConnection_id: Storage.outputs.queueConnection_id
    officeConnection_id: Connection.outputs.officeConnection_id
    queue_name: queue_name
  }
}

module Function './modules/function/function.bicep' = {
  name: 'functionDeploy'
  params: {
    //subscription: subscription
    //resource_group: resource_group
    //location: location
  }
}
