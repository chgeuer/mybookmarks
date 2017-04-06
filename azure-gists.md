
```
curl -s -H Metadata:true http://169.254.169.254/metadata/v1/maintenance
curl -s -H Metadata:true http://169.254.169.254/metadata/v1/InstanceInfo
curl -s -H Metadata:true http://169.254.169.254/metadata/v2/instance/compute?format=json | jq
curl -s -H Metadata:true http://169.254.169.254/metadata/v2/instance/network?format=json | jq
curl -s -H Metadata:true http://169.254.169.254/metadata/latest/instance/compute?format=json | jq
curl -s -H Metadata:true http://169.254.169.254/metadata/v2/instance/network?format=json | jq .interface[0].ipv4.ipaddress[0].ipaddress
```

## Special IP 168.63.129.16

- Src: https://blogs.msdn.microsoft.com/mast/2015/05/18/what-is-the-ip-address-168-63-129-16/

The IP address 168.63.129.16 is a virtual public IP address that is used to facilitate a communication channel to internal platform resources for the bring-your-own IP Virtual Network scenario.  Because the Azure platform allow customers to define any private or customer address space, this resource must be a unique public IP address.  It cannot be a private IP address as the address cannot be a duplicate of address space the customer defines.  This virtual public IP address facilitates the following things:

- Enables the VM Agent to communicating with the platform to signal it is in a “Ready” state
- Enables communication with the DNS virtual server to provide filtered name resolution to customers that do not define custom DNS servers.  This filtering ensures that customers can only resolve the hostnames of their deployment.
- Enables monitoring probes from the load balancer to determine health state for VMs in a load balanced set
- Enables PaaS role Guest Agent heartbeat messages
- The virtual public IP address 168.63.129.16 is used in all regions, all sovereign clouds, and will not change.  Therefore, it is recommended that this IP be allowed in any local firewall policies.  It should not be considered a security risk as only the internal Azure platform can source a message from that address.  Not doing so will result unexpected behavior in a variety of scenarios.

Additionally, traffic from virtual public IP address 168.63.129.16 that is communicating to the endpoint configured for a load balanced set monitor probe should not be considered attack traffic.  In a non-virtual network scenario, the monitor probe is sourced from a private IP.








## Determine Core Quota in a DC 

```
Install-Module -Force AzureRM
Import-AzureRM
Login-AzureRmAccount -Environment AzureCloud -SubscriptionId 724467b5-bee4-484b-bf13-d6a5505d2b51
Get-AzureRmVMUsage -Location "West Europe"
```


```
Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Compute | where { $_.ResourceTypes.ResourceTypeName -eq "locations/usages"} | select Locations
```

## List Storage Accounts

```
Get-AzureRmStorageAccount | select ResourceGroupName, StorageAccountName, AccountType, PrimaryLocation
```

# Retrieve Azure Usage

```
Import-AzureRM
Login-AzureRmAccount -Environment AzureCloud -SubscriptionId 724467b5-bee4-484b-bf13-d6a5505d2b51
Import-Module AzureRM.UsageAggregates

(Get-UsageAggregates -ReportedStartTime 2015-11-01 -ReportedEndTime 2015-11-03).UsageAggregations | `
	Select-Object -Expand Properties | `
	Select-Object MeterCategory, Quantity, Unit

(Get-UsageAggregates -ReportedStartTime 2015-11-01 -ReportedEndTime 2015-11-03).UsageAggregations | `
	Select-Object -Expand Properties | `
	Where { $_.MeterCategory -eq "Storage" } | `
	Select-Object MeterCategory, Quantity, Unit
```


```
Import-Module AzureRM.Network
Get-AzureRmApplicationGateway
Get-AzureRmPublicIpAddress | Select ResourceGroupName, Name, IpAddress
```
