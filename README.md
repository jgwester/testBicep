<h1>My Bicep Project</h1>

<p>Demo project for using bicep to easily create <b><u>AND</b></u> teardown resources on Azure.
The subscription id and resource group under which the resources are created should be supplied in using the correct 'parameters.json' file.</P>
<p>So you can check and deploy all resources using the commands below...</p>

<p>1) Check what resources will be created/updated.</p>

```bicep
az deployment group what-if --name mydeployment --resource-group <<enter_resource-group_name>> --template-file main.bicep --parameters '@parameters.json' [--mode Complete]
```
<p>2) Create/update resources in Azure.</p>

```bicep
az deployment group create --name mydeployment --resource-group <<enter_resource-group_name>> --template-file main.bicep --parameters '@parameters.json' [--mode Complete]
```
<b><i>Note</i></b>: Using 'Complete' mode will add missing resources defined in the bicep deployment and remove resources that are present but not defined in the bicep deployment. If you leave it out it will only increment missing resources by default.

<p>3) Cleanup resources after you are done.</p>

```
NOTE: there is no way of deleting resources related to a deployment. Using the 'Complete' mode from the first 2 statements you can do incremental creation of resources (only create what is not there AND delete what is not defined). So by creating an empty bicep file and deploying that to a resource-group you can remove everything which is in the resource-group

az deployment group create --name mydeployment --resource-group Jeroen-Wester-speeltuin --template-file empty.bicep --mode Complete
```

<p>There is an issue with the Office365 connection that is part of the Logic App. It gets created, but you need to login to the <a href="http://portal.azure.com">Azure Portal</a> to Authenticate the connection under the resource group where it has been created.</p>