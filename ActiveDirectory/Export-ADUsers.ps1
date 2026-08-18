<#
.SYNOPSIS
Exports Active Directory users to a CSV report.

.DESCRIPTION
Retrieves user accounts from Active Directory and exports
selected identity and account properties.

.NOTES
Requires the ActiveDirectory PowerShell module.
The script performs read-only operations.
#>

$OutputFile = Join-Path $PSScriptRoot "AD-Users.csv"

Import-Module ActiveDirectory -ErrorAction Stop

Write-Host "Retrieving Active Directory users..." -ForegroundColor Cyan

$Users = Get-ADUser -Filter * -Properties `
    Mail,
    Department,
    Title,
    Enabled,
    LastLogonDate,
    PasswordLastSet

$Users |
    Select-Object `
        Name,
        SamAccountName,
        UserPrincipalName,
        Mail,
        Department,
        Title,
        Enabled,
        LastLogonDate,
        PasswordLastSet |
    Sort-Object Name |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Active Directory user report created." -ForegroundColor Green
Write-Host "Users exported: $($Users.Count)"
Write-Host "File: $OutputFile"