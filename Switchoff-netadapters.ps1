Function Switchoff-Netadapter{

<#

.SYNOPSIS
Disable network adapters except Ethernet and restart the server.
.PARAMETER Errorlog
A file to save any errors occured while running Switchoff-Netadapter
Switchoff-Netadapter
#>
[cmdletbinding()]
Param(
[string]$ErrorLog = 'C:\Errors.txt',# The default path can be modified
[switch]$LogErrors
)

PROCESS {
Try{
Write-verbose "Checking on adapters"
$networkadapters=get-netadapter | where {$_.name -notmatch 'Ethernet*' -and '*local*'} -ErrorAction Stop
$networkadapters | Disable-Netadapter
# The command to enable adapters is Enable-Netadapter. It is available on Windows server 2012,2016 and Windows 10.  Defailt confirmation promt will not work as it is set to false
Write-Verbose "Network adapters are disabled. Server will be restarted in 10 sec"
Start-Sleep -Seconds 10
Restart-Computer 
 
}


Catch {
#create an error message
$msg="Failed to get network adapter.
$($_.Exception.Message)"
Write-Error $msg
if ($LogErrors) {
Write-Verbose "Logging errors to $errorlog"
$networkadapters | Out-File -FilePath $Errorlog -append
}
}

}
}

Switchoff-Netadapter  -verbose -logerrors
