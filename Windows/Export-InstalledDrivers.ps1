<#
.SYNOPSIS
Exports installed Windows drivers to CSV.
#>

Get-WindowsDriver -Online |
Select-Object Driver, ProviderName, Version |
Export-Csv Drivers.csv -NoTypeInformation

Write-Host "Driver report exported."