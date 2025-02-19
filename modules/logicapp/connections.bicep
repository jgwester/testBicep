param subscription string
param resource_group string
param location string

var connections_office365_name = 'office365'

resource connections_office365_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_office365_name
  location: location
  properties: {
    displayName: 'Office 365 Connection'
    customParameterValues: {}
    nonSecretParameterValues: {}
    api: {
      name: connections_office365_name
      displayName: 'Office 365 Outlook'
      description: 'Microsoft Office 365 is a cloud-based service that is designed to help meet your organization\'s needs for robust security, reliability, and user productivity.'
      iconUri: 'https://conn-afd-prod-endpoint-bmc9bqahasf3grgk.b01.azurefd.net/releases/v1.0.1722/1.0.1722.3975/${connections_office365_name}/icon.png'
      brandColor: '#0078D4'
      id: subscriptionResourceId('Microsoft.Web/locations/managedApis', location, connections_office365_name)
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: 'https://${environment().resourceManager}:443/subscriptions/${subscription}/resourceGroups/${resource_group}/providers/Microsoft.Web/connections/${connections_office365_name}/extensions/proxy/testconnection?api-version=2016-06-01'
        method: 'get'
      }
    ]
  }
}

output officeConnection_id string = connections_office365_name_resource.id
