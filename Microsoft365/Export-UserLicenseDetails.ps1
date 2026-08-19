<#
.SYNOPSIS
Exports Microsoft 365 license assignments per user.

.DESCRIPTION
Retrieves users from Microsoft Graph together with their assigned licenses
and exports one row per user and license SKU.

License SKU identifiers are resolved to readable SKU part numbers using the
tenant subscription list, so the report does not require a separate Graph
call for every user.

.PARAMETER IncludeUnlicensed
Include users with no licenses assigned, marked as UNLICENSED.

.EXAMPLE
.\Export-UserLicenseDetails.ps1

.NOTES
Requires the Microsoft.Graph.Users and
Microsoft.Graph.Identity.DirectoryManagement modules.

Requires the User.Read.All and Organization.Read.All permissions.
The script performs read-only operations.
#>

[CmdletBinding()]
param(
    [switch]$IncludeUnlicensed
)

$OutputFile = Join-Path $PSScriptRoot "M365-UserLicenseDetails.csv"

foreach ($Module in @("Microsoft.Graph.Users", "Microsoft.Graph.Identity.DirectoryManagement")) {
    if (-not (Get-Module -ListAvailable -Name $Module)) {
        Write-Host "$Module is not installed." -ForegroundColor Yellow
        Write-Host "Install it with: Install-Module $Module -Scope CurrentUser"
        exit 1
    }
}

if (-not (Get-MgContext)) {
    Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
    Connect-MgGraph -Scopes "User.Read.All", "Organization.Read.All" -NoWelcome
}

Write-Host "Retrieving tenant license SKUs..." -ForegroundColor Cyan

$SkuLookup = @{}

foreach ($Sku in (Get-MgSubscribedSku -All)) {
    $SkuLookup[$Sku.SkuId] = $Sku.SkuPartNumber
}

Write-Host "Retrieving Microsoft 365 users..." -ForegroundColor Cyan

# assignedLicenses is requested with the user objects, which avoids one
# Graph call per user and keeps the script usable in large tenants.
$Users = Get-MgUser `
    -All `
    -Property "id,displayName,userPrincipalName,accountEnabled,assignedLicenses"

$Report = foreach ($User in $Users) {

    if (-not $User.AssignedLicenses -or $User.AssignedLicenses.Count -eq 0) {

        if ($IncludeUnlicensed) {
            [PSCustomObject]@{
                DisplayName       = $User.DisplayName
                UserPrincipalName = $User.UserPrincipalName
                AccountEnabled    = $User.AccountEnabled
                SkuPartNumber     = "UNLICENSED"
            }
        }

        continue
    }

    foreach ($License in $User.AssignedLicenses) {

        $SkuName = if ($SkuLookup.ContainsKey($License.SkuId)) {
            $SkuLookup[$License.SkuId]
        }
        else {
            $License.SkuId
        }

        [PSCustomObject]@{
            DisplayName       = $User.DisplayName
            UserPrincipalName = $User.UserPrincipalName
            AccountEnabled    = $User.AccountEnabled
            SkuPartNumber     = $SkuName
        }
    }
}

$Report |
    Sort-Object UserPrincipalName, SkuPartNumber |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "License detail report created." -ForegroundColor Green
Write-Host "Users processed    : $($Users.Count)"
Write-Host "Assignments written: $(@($Report).Count)"
Write-Host "File: $OutputFile"
