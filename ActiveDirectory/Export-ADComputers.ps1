<#
.SYNOPSIS
Exports Active Directory computer inventory.

.DESCRIPTION
Retrieves computer objects from Active Directory and exports
selected inventory and operating system properties to CSV.

.NOTES
Requires the ActiveDirectory PowerShell module.
The script performs read-only operations.
#>

$OutputFile = Join-Path $PSScriptRoot "AD-Computers.csv"

Import-Module ActiveDirectory -ErrorAction Stop

Write-Host "Retrieving Active Directory computers..." -ForegroundColor Cyan

$Computers = Get-ADComputer `
    -Filter * `
    -Properties `
        OperatingSystem,
        OperatingSystemVersion,
        IPv4Address,
        LastLogonDate,
        Enabled

$Computers |
    Select-Object `
        Name,
        DNSHostName,
        OperatingSystem,
        OperatingSystemVersion,
        IPv4Address,
        LastLogonDate,
        Enabled |
    Sort-Object Name |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Active Directory computer report created." -ForegroundColor Green
Write-Host "Computers exported: $($Computers.Count)"
Write-Host "File: $OutputFile"