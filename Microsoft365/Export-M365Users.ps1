<#
.SYNOPSIS
Exports Microsoft 365 users to a CSV file.

.DESCRIPTION
Retrieves user information from Microsoft Graph and exports
selected properties to a CSV report.

.NOTES
Requires the Microsoft.Graph PowerShell SDK.
Requires appropriate Microsoft Entra permissions.

The script does not store credentials or secrets.
#>

$OutputFile = Join-Path $PSScriptRoot "M365-Users.csv"

$RequiredModule = "Microsoft.Graph.Users"

if (-not (Get-Module -ListAvailable -Name $RequiredModule)) {
    Write-Host "Microsoft Graph Users module is not installed." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Install it with:"
    Write-Host "Install-Module Microsoft.Graph.Users -Scope CurrentUser"
    exit 1
}

if (-not (Get-MgContext)) {
    Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan

    Connect-MgGraph -Scopes "User.Read.All" -NoWelcome
}

Write-Host "Retrieving Microsoft 365 users..." -ForegroundColor Cyan

$Users = Get-MgUser -All `
    -Property "displayName,userPrincipalName,mail,accountEnabled,jobTitle,department"

$Users |
    Select-Object `
        DisplayName,
        UserPrincipalName,
        Mail,
        AccountEnabled,
        JobTitle,
        Department |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "User report created successfully." -ForegroundColor Green
Write-Host "File: $OutputFile"
Write-Host "Users exported: $($Users.Count)"