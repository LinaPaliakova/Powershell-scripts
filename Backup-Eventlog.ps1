function Backup-Eventlog {

<#
.SYNOPSIS
Backs up and clears event logs on remote computers.
.DESCRIPTION
The Backup-Eventlog cmdlet backs up and clears event logs from local and remote computers. By default, `Back-EventLog` backs up all logs from the local computer. To 
back up logs from remote computers, use the computerName parameter.
.PARAMETER computername
Maximum of 4 computer names can be specified. 
.PARAMETER path
Network path where log files will be saved. Default path is D:\temp.
.EXAMPLE 
Backup-EventLog -computername Server01 -path "C:\users\temp"

#>

[cmdletbinding()]
param(
[Parameter(Mandatory=$true, ValueFromPipeline=$True)]
[ValidateCount(1,4)] # the script will fail on validation if more than 4 computer names is provided.
[string[]]$computername,
[ValidateScript({ # The script will fail on validation if the path doesn't exist.
if( -Not ($_ | Test-Path) ){
 throw "File or folder does not exist"
 }
 return $true
 })]
[Parameter(Mandatory=$true,ValueFromPipeline=$True)]
[string]$path="D:\temp\"

)

Begin{
Write-Verbose "Starting Back-up logs"
$now=get-date
$file=$path + "Logs_for_"+ $now.ToString("yyyy-MM-dd") + ".evtx" 

}


Process{
Try{
foreach ($computer in $computername){
  
Write-Verbose "Backing up event logs"
$logs= (get-wmiobject win32_nteventlogfile -ComputerName $computername -ErrorAction Continue).backupeventlog($file)
Write-Verbose "Event logs have been saved under specified path"
Get-EventLog -LogName * -ErrorAction Continue | Foreach { Clear-EventLog -LogName $_.log }
Write-Verbose "Event logs were cleared"
}

}

Catch {
$msg="Failed to get log data.
$($_.Exception.Message)"
Write-Error $msg


}
}
End{

Write-Verbose "Backup-log finished"

}

}

Backup-EventLog -verbose

