<#
.SYNOPSIS
Exports the latest 100 System event logs.
#>

Get-EventLog System -Newest 100 |
Export-Csv SystemEvents.csv -NoTypeInformation

Write-Host "System event log exported."