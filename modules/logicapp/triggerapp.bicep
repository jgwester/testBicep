param subscription string
param location string
param storageAccount_name string
param storageConnection_id string
param officeConnection_id string
param queue_name string

var queue_api_name = 'azurequeues'

resource myLogicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: 'sendQueueMail'
  location: location
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        'When_there_are_messages_in_a_queue_(V2)': {
          recurrence: {
            frequency: 'Minute'
            interval: 10
          }
          evaluatedRecurrence: {
            frequency: 'Minute'
            interval: 10
          }
          splitOn: '@triggerBody()?[\'QueueMessagesList\']?[\'QueueMessage\']'
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'${queue_api_name}\'][\'connectionId\']'
              }
            }
            method: 'get'
            path: '/v2/storageAccounts/@{encodeURIComponent(encodeURIComponent(\'${storageAccount_name}\'))}/queues/@{encodeURIComponent(\'${queue_name}\')}/message_trigger'
          }
        }
      }
      actions: {
        'Remove_message_(V2)': {
          runAfter: {
            'Send_an_email_(V2)': [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'${queue_api_name}\'][\'connectionId\']'
              }
            }
            method: 'delete'
            path: '/v2/storageAccounts/@{encodeURIComponent(encodeURIComponent(\'AccountNameFromSettings\'))}/queues/@{encodeURIComponent(\'${queue_name}\')}/messages/@{encodeURIComponent(triggerBody()?[\'MessageId\'])}'
            queries: {
              popreceipt: '@triggerBody()?[\'PopReceipt\']'
            }
          }
        }
        'Send_an_email_(V2)': {
          runAfter: {}
          type: 'ApiConnection'
          inputs: {
            body: {
              Body: '<p class="editor-paragraph">@{triggerBody()?[\'MessageText\']}</p>'
              Importance: 'Normal'
              Subject: 'Received Queue Message'
              To: 'jeroen.wester@syntouch.nl'
            }
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'office365\'][\'connectionId\']'
              }
            }
            method: 'post'
            path: '/v2/Mail'
          }
        }
      }
    }
    parameters: {
      '$connections': {
        value: {
          azurequeues: {
            connectionId: storageConnection_id
            connectionName: queue_api_name
            id: '/subscriptions/${subscription}/providers/Microsoft.Web/locations/${location}/managedApis/${queue_api_name}'
          }
          office365: {
            connectionId: officeConnection_id
            connectionName: 'office365'
            id: '/subscriptions/${subscription}/providers/Microsoft.Web/locations/${location}/managedApis/office365'
          }
        }
      }
    }
  }
}
