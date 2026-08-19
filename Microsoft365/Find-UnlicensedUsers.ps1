<#
.SYNOPSIS
Finds Microsoft 365 users without assigned licenses.

.DESCRIPTION
Queries Microsoft Graph for member accounts that have no Microsoft 365
licenses assigned and exports the results to a CSV report.

.PARAMETER IncludeDisabled
Include accounts that are disabled. By default only enabled accounts are
reported, since disabled accounts are normally expected to be unlicensed.

.EXAMPLE
.\Find-UnlicensedUsers.ps1

.NOTES
Requires the Microsoft.Graph.Users PowerShell module.
Requires the User.Read.All permission.

The script performs read-only operations and does not store credentials.
#>

[CmdletBinding()]
param(
    [switch]$IncludeDisabled
)

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

# The backtick is required. Without it PowerShell would expand $count as a
# local variable and send a malformed filter to Microsoft Graph.
# Counting filters are advanced queries, so ConsistencyLevel must be eventual.
$Filter = "assignedLicenses/`$count eq 0 and userType eq 'Member'"

Write-Host "Searching for unlicensed users..." -ForegroundColor Cyan

try {
    $Users = Get-MgUser `
        -Filter $Filter `
        -ConsistencyLevel eventual `
        -CountVariable UnlicensedCount `
        -All `
        -Property "displayName,userPrincipalName,mail,accountEnabled,department,jobTitle" `
        -ErrorAction Stop
}
catch {
    Write-Host ""
    Write-Host "Graph query failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

if (-not $IncludeDisabled) {
    $Users = $Users | Where-Object { $_.AccountEnabled }
}

if (-not $Users) {
    Write-Host ""
    Write-Host "No unlicensed users were found." -ForegroundColor Green
    return
}

$Users |
    Select-Object `
        DisplayName,
        UserPrincipalName,
        Mail,
        AccountEnabled,
        Department,
        JobTitle |
    Sort-Object UserPrincipalName |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Unlicensed user report created." -ForegroundColor Green
Write-Host "Users exported: $($Users.Count)"
Write-Host "File: $OutputFile"
