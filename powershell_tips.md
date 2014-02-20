# Show Connected Physical Adapters

How can I see which physical network adapters on my Windows 8.1 computer are up and connected?

Get-NetAdapter -physical | where status -eq 'up'

# Get Network Adapter Power Management Settings

Get-NetAdapterPowerManagement -Name ethernet

# Gathering Network Statistics with PowerShell

http://blogs.technet.com/b/heyscriptingguy/archive/2014/01/17/gathering-network-statistics.aspx

# Find Networking Counters

Get-Counter -ListSet * | select countersetname | where countersetname -match 'ipv6'


nic.OperatioStatus = Up
ipProps.UnicastAddtesses[1].Address
