<#
.SYNOPSIS
Exports Microsoft 365 license details for users.

.DESCRIPTION
Retrieves users from Microsoft Graph and exports their
assigned license SKU information to a CSV report.

.NOTES
Requires the Microsoft.Graph.Users PowerShell module.
Requires User.Read.All permission.
#>

$OutputFile = Join-Path $PSScriptRoot "M365-UserLicenseDetails.csv"

if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Users)) {
    Write-Host "Microsoft Graph Users module is not installed." -ForegroundColor Yellow
    Write-Host "Install it with: Install-Module Microsoft.Graph.Users -Scope CurrentUser"
    exit 1
}

if (-not (Get-MgContext)) {
    Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
    Connect-MgGraph -Scopes "User.Read.All" -NoWelcome
}

Write-Host "Retrieving Microsoft 365 users..." -ForegroundColor Cyan

$Users = Get-MgUser `
    -All `
    -Property "displayName,userPrincipalName,accountEnabled"

$Report = foreach ($User in $Users) {

    $Licenses = Get-MgUserLicenseDetail `
        -UserId $User.Id `
        -All

    if ($Licenses.Count -eq 0) {

        [PSCustomObject]@{
            DisplayName       = $User.DisplayName
            UserPrincipalName = $User.UserPrincipalName
            AccountEnabled    = $User.AccountEnabled
            SkuPartNumber     = "UNLICENSED"
        }

        continue
    }

    foreach ($License in $Licenses) {

        [PSCustomObject]@{
            DisplayName       = $User.DisplayName
            UserPrincipalName = $User.UserPrincipalName
            AccountEnabled    = $User.AccountEnabled
            SkuPartNumber     = $License.SkuPartNumber
        }
    }
}

$Report |
    Sort-Object UserPrincipalName, SkuPartNumber |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "License detail report created." -ForegroundColor Green
Write-Host "Report: $OutputFile"
Write-Host "Users processed: $($Users.Count)"