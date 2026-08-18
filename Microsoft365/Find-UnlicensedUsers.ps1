<#
.SYNOPSIS
Finds Microsoft 365 users without assigned licenses.

.DESCRIPTION
Queries Microsoft Graph for member users that do not have
any Microsoft 365 licenses assigned and exports the results
to a CSV report.

.NOTES
Requires the Microsoft.Graph.Users PowerShell module.
Requires User.Read.All permission.
#>

$OutputFile = Join-Path $PSScriptRoot "M365-UnlicensedUsers.csv"

if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Users)) {
    Write-Host "Microsoft Graph Users module is not installed." -ForegroundColor Yellow
    Write-Host "Install it with: Install-Module Microsoft.Graph.Users -Scope CurrentUser"
    exit 1
}

if (-not (Get-MgContext)) {
    Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
    Connect-MgGraph -Scopes "User.Read.All" -NoWelcome
}

Write-Host "Searching for unlicensed users..." -ForegroundColor Cyan

$Users = Get-MgUser `
    -Filter "assignedLicenses/$count eq 0 and userType eq 'Member'" `
    -ConsistencyLevel eventual `
    -CountVariable UnlicensedCount `
    -All `
    -Property "displayName,userPrincipalName,mail,accountEnabled,department,jobTitle"

$Users |
    Select-Object `
        DisplayName,
        UserPrincipalName,
        Mail,
        AccountEnabled,
        Department,
        JobTitle |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Unlicensed users found: $UnlicensedCount" -ForegroundColor Green
Write-Host "Report: $OutputFile"