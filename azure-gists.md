

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
