# Sniffing Azure Powershell Traffic

```console
SET HTTP_PROXY=http://127.0.0.1:8888/
SET HTTPS_PROXY=http://127.0.0.1:8888/
SET HTTPPROXY=http://127.0.0.1:8888/
SET HTTPSPROXY=http://127.0.0.1:8888/
SET NODE_TLS_REJECT_UNAUTHORIZED=0

"C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" -NoExit -ExecutionPolicy Bypass -File "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Services\ShortcutStartup.ps1"
```

## Links

- http://blogs.msdn.com/b/avkashchauhan/archive/2013/01/30/using-fiddler-to-decipher-windows-azure-powershell-or-rest-api-https-traffic.aspx

## CustomRules.js

```csharpjavascriptish
static function OnBeforeRequest(oSession: Session) {
    oSession["https-Client-Certificate"]= "C:\\Users\\chgeuer\\Desktop\\txxx.cer"; 
```