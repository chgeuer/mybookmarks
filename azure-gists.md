

## Determine Core Quota in a DC 

```
Install-Module -Force AzureRM
Import-AzureRM
Login-AzureRmAccount -Environment AzureCloud -SubscriptionId 724467b5-bee4-484b-bf13-d6a5505d2b51
Get-AzureRmVMUsage -Location "West Europe"
```

