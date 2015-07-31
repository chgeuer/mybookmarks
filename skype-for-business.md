 
src: https://github.com/chgeuer/mybookmarks/blob/master/skype-for-business.md

# Playing with O365 and Skype fpr Business

## Get an O365 trial/development tenant

- Long-running test tenant (type E3) via http://www.microsoftofficedemos.com
- Regular (shorter) test tenant (type E3) via http://go.microsoft.com/fwlink/p/?LinkID=403802&culture=en-US&country=DE 

## Lync / Skype for Business Gotchas

- When appending `?sl=1` query string to a meeting invitation URL (e.g. `https://join.microsoft.com/meet/demouser120/FF66XXQ?sl=1`, it forces anonymous users into the web app. See also [this](https://support.office.com/de-de/article/Teilnehmen-an-einer-Skype-Besprechung-mit-der-Skype-for-Business-Web-App-4828ad18-ed21-422a-a870-94d676d4b72a)
- "UCWA" (Unified Communications Web API) not supported by O365

## Management APIs

- [Install Windows PowerShell for single sign-on with AD FS](https://msdn.microsoft.com/en-us/library/azure/jj151814.aspx)
- [Manage Azure AD using Windows PowerShell](https://msdn.microsoft.com/en-us/library/azure/jj151815.aspx#bkmk_installmodule)
- [Manage licenses and subscriptions for Office 365](https://code.msdn.microsoft.com/office/Office-365-Manage-licenses-fb2c6413)
- http://www.powershellmagazine.com/2012/04/23/provisioning-and-licensing-office-365-accounts-with-powershell/
- [Access Azure AD graph API from C#](https://github.com/AzureADSamples/ConsoleApp-GraphAPI-DotNet)
- [Azure Active Directory Code Samples](https://msdn.microsoft.com/en-us/library/azure/dn646737.aspx) / [code](https://github.com/AzureADSamples)


### Installation of all the packages

- Install [Microsoft Online Services Sign-In Assistant for IT Professionals - Beta 7.250.4551.0](http://download.microsoft.com/download/C/1/7/C17BEB52-BB8A-4C7F-86F3-AAF17BB3682A/msoidcli_64.msi). 
- Install [Azure Active Directory Module for Windows PowerShell (64-bit version)](https://bposast.vo.msecnd.net/MSOPMW/Current/amd64/AdministrationConfig-en.msi). 
- Install [Skype for Business Online, Windows PowerShell Module](https://www.microsoft.com/en-us/download/details.aspx?id=39366)

Make sure to install the Beta sign-in assistant, not the [RTW 7.250.4303.0](http://download.microsoft.com/download/7/1/E/71EF1D05-A42C-4A1F-8162-96494B5E615C/msoidcli_64bit.msi). Azure Active Directory Module for Windows PowerShell has a launch condition `MSOIDCRLVERSION >= "7.250.4358"`, which is not satisfied by the RTW version. If you are a smart guy and use [something like Orca or SuperOrca](http://www.pantaray.com/msi_super_orca.html) to remove the launch condition, running `Connect-MsolService` creates stuff like `The type initializer for 'Microsoft.Online.Administration.Automation.ConnectMsolService' threw an exception`. So just use the beta. 

When you plan to use all the MSOnline and Powershell bits from within a C# app, the Powershell Runtime in your .NET app is most certainly a 32bit runtime. The MSOnline Powershell Module is only in the 64-bit folder (`C:\Windows\System32\WindowsPowerShell\v1.0\Modules`), so [copy the bits over](http://blog.clauskonrad.net/2013/06/powershell-and-c-cant-load-msonline.html):

```Powershell
Copy-Item -Recurse -Destination "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules" -Path "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\MSOnline" 
Copy-Item -Recurse -Destination "C:\Windows\SysWOW64\WindowsPowerShell\v1.0\Modules" -Path "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\MSOnlineExtended" 
```



## Powershell commands

```Powershell
New-MsolUser -UserPrincipalName demo1@chgeuerimcdemo.onmicrosoft.com -DisplayName 'Demo User 1' -FirstName "Chris" -LastName "Geuer-Pollmann" -LicenseAssignment chgeuerimcdemo:ENTERPRISEPACK -UsageLocation DE

Password UserPrincipalName                    DisplayName isLicensed
-------- -----------------                    ----------- ----------
Homo3136 demo1@chgeuerimcdemo.onmicrosoft.com Demo User 1 True
```

```Powershell
$credential = Get-Credential "chgeuer@chgeuerimcdemo.onmicrosoft.com"
Connect-MsolService  -Credential $credential

Get-MsolUser -UnlicensedUsersOnly





Import-Module -Name "C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules\MSOnline\MSOnline.psd1"
Import-Module -Name "C:\Program Files\Common Files\Skype for Business Online\Modules\SkypeOnlineConnector\SkypeOnlineConnector.psd1"

$session = New-CsOnlineSession -Credential $credential 
Import-PSSession $session
Get-CsTenant | select DisplayName, TenantId, DomainUrlMap

Get-CsOnlineUser | select UserPrincipalName

Enable-CsUser
```

```Powershell
```

```Powershell
```





