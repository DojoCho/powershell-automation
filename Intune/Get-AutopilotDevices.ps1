<#
.SYNOPSIS
Exports Windows Autopilot device identities.

.DESCRIPTION
Retrieves Windows Autopilot device identities from Microsoft Intune
through Microsoft Graph and exports selected properties to CSV.

.NOTES
Requires the Microsoft.Graph.DeviceManagement.Enrollment module.
Requires DeviceManagementServiceConfig.Read.All permission.

The script performs read-only operations.
#>

$OutputFile = Join-Path $PSScriptRoot "Intune-AutopilotDevices.csv"

$RequiredModule = "Microsoft.Graph.DeviceManagement.Enrollment"

if (-not (Get-Module -ListAvailable -Name $RequiredModule)) {
    Write-Host "Microsoft Graph Device Management Enrollment module is not installed." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Install it with:"
    Write-Host "Install-Module Microsoft.Graph.DeviceManagement.Enrollment -Scope CurrentUser"
    exit 1
}

if (-not (Get-MgContext)) {
    Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan

    Connect-MgGraph `
        -Scopes "DeviceManagementServiceConfig.Read.All" `
        -NoWelcome
}

Write-Host "Retrieving Windows Autopilot devices..." -ForegroundColor Cyan

$Devices = Get-MgDeviceManagementWindowsAutopilotDeviceIdentity `
    -All `
    -Property "displayName,serialNumber,manufacturer,model,groupTag,purchaseOrderIdentifier,deploymentProfileAssignmentStatus"

$Devices |
    Select-Object `
        DisplayName,
        SerialNumber,
        Manufacturer,
        Model,
        GroupTag,
        PurchaseOrderIdentifier,
        DeploymentProfileAssignmentStatus |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Autopilot device report created successfully." -ForegroundColor Green
Write-Host "Devices exported: $($Devices.Count)"
Write-Host "File: $OutputFile"