 
src: https://github.com/chgeuer/mybookmarks/blob/master/skype-for-business.md / http://tinyurl.com/s4bimc

# Playing with O365 and Skype for Business

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
- [Managing users and user account properties in Skype for Business Online](https://technet.microsoft.com/en-us/library/dn362790(v=ocs.15).aspx)

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

After that copy operation, loading the modules should work: 

```Powershell
PS C:\> Import-Module MSOnline
PS C:\> Import-Module "C:\Program Files\Common Files\Skype for Business Online\Modules\SkypeOnlineConnector\SkypeOnlineConnector.psd1"
PS C:\> Get-Module

ModuleType Version    Name                                ExportedCommands
---------- -------    ----                                ----------------
Manifest   3.1.0.0    Microsoft.PowerShell.Management     {Add-Computer, Add-Content, Checkpoint-Computer, Clear-Con...
Manifest   3.0.0.0    Microsoft.WSMan.Management          {Connect-WSMan, Disable-WSManCredSSP, Disconnect-WSMan, En...
Manifest   1.0        MSOnline                            {Add-MsolAdministrativeUnitMember, Add-MsolForeignGroupToR...
Script     6.0.0.0    SkypeOnlineConnector                {New-CsOnlineSession, Set-WinRMNetworkDelayMS}
```

## Powershell commands

### Sign in to MS Online

```Powershell
$credential = Get-Credential "chgeuer@chgeuerimcdemo.onmicrosoft.com"
Connect-MsolService  -Credential $credential
```

### List unlicensed users

```Powershell
Get-MsolUser -UnlicensedUsersOnly
```

### Create a user

```Powershell
New-MsolUser -UserPrincipalName demo1@chgeuerimcdemo.onmicrosoft.com -DisplayName 'Demo User 1' -FirstName "Chris" -LastName "Geuer-Pollmann" -LicenseAssignment chgeuerimcdemo:ENTERPRISEPACK -UsageLocation DE

Password UserPrincipalName                    DisplayName isLicensed
-------- -----------------                    ----------- ----------
Hogo3136 demo1@chgeuerimcdemo.onmicrosoft.com Demo User 1 True
```

### Manage Skype

```Powershell
$session = New-CsOnlineSession -Credential $credential 
Import-PSSession $session
Get-CsTenant | select DisplayName, TenantId, DomainUrlMap

Get-CsOnlineUser | select UserPrincipalName

Enable-CsUser
```

## Azure AD 

- [STS Integration Paper using WS-* Protocols](https://www.microsoft.com/en-us/download/details.aspx?id=41185): These documents detail the agreement for STSs to Interop with Azure Active Directory using the WS-Federation and WS-Trust protocols
	- [Azure Active Directory federation compatibility list Program Description July 2015](http://download.microsoft.com/download/3/7/9/379FF864-AC01-4CF1-8130-B34708C713BD/Azure%20Active%20Directory%20federation%20compatibility%20list%20Program%20Description%20July%202015.pdf)
	- [STS Integration Interoperability Scenario Requirements July 2015](http://download.microsoft.com/download/3/7/9/379FF864-AC01-4CF1-8130-B34708C713BD/STS%20Integration%20Interoperability%20Scenario%20Requirements%20July%202015.pdf)
	- [STS Integration Paper using WS Protocols July 2015](http://download.microsoft.com/download/3/7/9/379FF864-AC01-4CF1-8130-B34708C713BD/STS%20Integration%20Paper%20using%20WS%20Protocols%20July%202015.docx)
- [Azure Active Directory federation compatibility list: third-party identity providers that can be used to implement single sign-on (http://aka.ms/SSOProviders)](https://technet.microsoft.com/en-us/library/jj679342.aspx)
- [Use a SAML 2.0 identity provider to implement single sign-on](https://msdn.microsoft.com/en-us/library/azure/dn641269.aspx): All other clients are not available in this sign-on scenario with your SAML 2.0 Identity Provider. For example, the Lync 2010 desktop client is not able to login into the service with your SAML 2.0 Identity Provider configured for single sign-on.
- For debugging your own STS, use the [Microsoft Connectivity Analyzer Client](http://go.microsoft.com/fwlink/?LinkID=313782)
- [Announcing support for SAML 2.0 federation with Office 365](https://blogs.office.com/2014/03/06/announcing-support-for-saml-2-0-federation-with-office-365/)
- [Office 365 - User Account Management](https://technet.microsoft.com/en-us/library/office-365-user-account-management.aspx)
- [Single sign-on roadmap](https://technet.microsoft.com/library/hh967643.aspx)
- When rolling an own STS as IdP for Azure AD, the vendor needs to be onboarded through "'Works with office 365' for Identity Providers". 
	- STS must talk WS-Trust / WS-MetadataExchange
	- Lync Online requires a WS-MEX Endpoint at the IDP.
- Skype for Business
	- [Federation and Public IM Connectivity](https://technet.microsoft.com/en-us/library/skype-for-business-online-federation-and-public-im-conectivity.aspx)
	- [Anonymous join from Skype for Business and Lync clients](http://blogs.technet.com/b/scottstu/archive/2015/04/03/anonymous-join-from-skype-for-business-and-lync-clients.aspx)
