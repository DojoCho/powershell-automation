<#
.SYNOPSIS
Exports Microsoft Intune managed devices to CSV.

.DESCRIPTION
Retrieves devices managed by Microsoft Intune through
Microsoft Graph and exports selected device properties.

.NOTES
Requires the Microsoft.Graph.DeviceManagement module.
Requires DeviceManagementManagedDevices.Read.All permission.

The script does not store credentials or secrets.
#>

$OutputFile = Join-Path $PSScriptRoot "Intune-ManagedDevices.csv"

$RequiredModule = "Microsoft.Graph.DeviceManagement"

if (-not (Get-Module -ListAvailable -Name $RequiredModule)) {
    Write-Host "Microsoft Graph Device Management module is not installed." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Install it with:"
    Write-Host "Install-Module Microsoft.Graph.DeviceManagement -Scope CurrentUser"
    exit 1
}

if (-not (Get-MgContext)) {
    Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan

    Connect-MgGraph `
        -Scopes "DeviceManagementManagedDevices.Read.All" `
        -NoWelcome
}

Write-Host "Retrieving Intune managed devices..." -ForegroundColor Cyan

$Devices = Get-MgDeviceManagementManagedDevice `
    -All `
    -Property "deviceName,operatingSystem,osVersion,manufacturer,model,userPrincipalName,complianceState,lastSyncDateTime,managementAgent"

$Devices |
    Select-Object `
        DeviceName,
        OperatingSystem,
        OsVersion,
        Manufacturer,
        Model,
        UserPrincipalName,
        ComplianceState,
        LastSyncDateTime,
        ManagementAgent |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Intune device report created successfully." -ForegroundColor Green
Write-Host "Devices exported: $($Devices.Count)"
Write-Host "File: $OutputFile"