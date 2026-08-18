<#
.SYNOPSIS
Generates a Microsoft 365 license utilization report.

.DESCRIPTION
Retrieves subscribed Microsoft 365 SKUs and calculates
assigned and available license counts.

.NOTES
Requires the Microsoft.Graph PowerShell SDK.
Requires appropriate Microsoft Entra permissions.

The script does not store credentials or secrets.
#>

$OutputFile = Join-Path $PSScriptRoot "M365-LicenseReport.csv"

$RequiredModule = "Microsoft.Graph.Identity.DirectoryManagement"

if (-not (Get-Module -ListAvailable -Name $RequiredModule)) {
    Write-Host "Microsoft Graph Identity Directory Management module is not installed." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Install it with:"
    Write-Host "Install-Module Microsoft.Graph.Identity.DirectoryManagement -Scope CurrentUser"
    exit 1
}

if (-not (Get-MgContext)) {
    Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan

    Connect-MgGraph -Scopes "LicenseAssignment.Read.All" -NoWelcome
}

Write-Host "Retrieving Microsoft 365 license information..." -ForegroundColor Cyan

$Licenses = Get-MgSubscribedSku -All

$Report = foreach ($License in $Licenses) {

    $Enabled = $License.PrepaidUnits.Enabled
    $Consumed = $License.ConsumedUnits
    $Available = $Enabled - $Consumed

    [PSCustomObject]@{
        SkuPartNumber = $License.SkuPartNumber
        CapabilityStatus = $License.CapabilityStatus
        TotalLicenses = $Enabled
        AssignedLicenses = $Consumed
        AvailableLicenses = $Available
    }
}

$Report |
    Sort-Object SkuPartNumber |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "License report created successfully." -ForegroundColor Green
Write-Host "File: $OutputFile"