<#
.SYNOPSIS
Finds inactive Active Directory user accounts.

.DESCRIPTION
Identifies enabled user accounts that have not logged in
within the specified number of days.

.PARAMETER InactiveDays
Number of days without a recorded logon before an account
is considered inactive.

.NOTES
Requires the ActiveDirectory PowerShell module.
The script performs read-only operations.
#>

param(
    [int]$InactiveDays = 90
)

$OutputFile = Join-Path $PSScriptRoot "AD-InactiveUsers.csv"

Import-Module ActiveDirectory -ErrorAction Stop

$CutoffDate = (Get-Date).AddDays(-$InactiveDays)

Write-Host "Searching for inactive users..." -ForegroundColor Cyan
Write-Host "Inactive threshold: $InactiveDays days"

$Users = Get-ADUser `
    -Filter { Enabled -eq $true } `
    -Properties LastLogonDate, Mail, Department, Title

$InactiveUsers = $Users |
    Where-Object {
        $null -eq $_.LastLogonDate -or $_.LastLogonDate -lt $CutoffDate
    }

$InactiveUsers |
    Select-Object `
        Name,
        SamAccountName,
        UserPrincipalName,
        Mail,
        Department,
        Title,
        Enabled,
        LastLogonDate |
    Sort-Object LastLogonDate |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Inactive user report created." -ForegroundColor Green
Write-Host "Inactive users found: $($InactiveUsers.Count)"
Write-Host "File: $OutputFile"