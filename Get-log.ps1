function Get-log {

<#
.SYNOPSIS
Gathers Windows Event Viewer logs and export data into .csv files.
.DESCRIPTION
Get-log cmdlet gets events and event logs from local computer based on log name and export informatio into csv file.
.PARAMETER OutputDir
Indicates the destination folder where events shoud be exported.
.PARAMETER applicationLogs
Indicates a type of logs. Set by default to $true.
.PARAMETER systemLogs
Indicates a type of logs.Set by default to $true.
.PARAMETER fromDate
Specifies the date from which you want to get data.
.PARAMETER severity
Specifies log level.
.PARAMETER Errorlog
A file to save any errors occured while running Get-log.
.EXAMPLE
Get-log -outputDir D:\temp -applicationLogs $true -systemLogs $false  -severity 'Warning'

#>
[cmdletbinding()]
param(
[string]$outputDir='D:\temp\',
[bool] $applicationLogs=$true,
[bool] $systemLogs=$true,
[DateTime]$fromDate=(Get-Date).AddDays(-30),
[string[]]$severity=@('Error','Warning')

)

Begin{

Write-Verbose "Starting Get-log. Requesting data"
$now=get-date
$ExportFileApp=$outputDir +"ApplicationLogs_" + $now.ToString("yyyy-MM-dd---hh-mm-ss") + ".csv"
$ExportFileSys=$outputDir + "SystemLogs_" + $now.ToString("yyyy-MM-dd---hh-mm-ss") + ".csv"

}


Process{
Try{

If ($applicationLogs -eq $true){
     Get-EventLog -LogName Application -ErrorAction Stop | Select MachineName, TimeGenerated,EntryType, Source, Message | ConvertTo-Csv | Export-Csv $ExportFileApp -NoTypeInfo 
     Write-Verbose "Application logs successfullly exported" 
} 

}

Catch{
$msg="Failed to get  Application log data.
$($_.Exception.Message)"
Write-Error $msg

}

Try{

If ($systemLogs -eq $true){
     Get-EventLog -LogName System  -ErrorAction Stop| Select MachineName, TimeGenerated,EntryType, Source, Message | ConvertTo-Csv | Export-csv  $ExportfileSys -NoTypeInfo 
     Write-Verbose " System Logs successfullly exported" 
}


}


Catch{
$msg="Failed to get log data.
$($_.Exception.Message)"
Write-Error $msg

}
}

End {

Write-Verbose "Get-log finished"

}
}


