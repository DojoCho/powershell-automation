<#
.SYNOPSIS
Finds non-compliant devices in Microsoft Intune.

.DESCRIPTION
Retrieves Intune managed devices and exports devices whose
compliance state is not compliant.

.NOTES
Requires the Microsoft.Graph.DeviceManagement module.
Requires DeviceManagementManagedDevices.Read.All permission.

The script does not modify devices or policies.
#>

$OutputFile = Join-Path $PSScriptRoot "Intune-NonCompliantDevices.csv"

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

Write-Host "Checking Intune device compliance..." -ForegroundColor Cyan

$Devices = Get-MgDeviceManagementManagedDevice `
    -All `
    -Property "deviceName,operatingSystem,userPrincipalName,complianceState,lastSyncDateTime"

$NonCompliantDevices = $Devices |
    Where-Object {
        $_.ComplianceState -ne "compliant"
    }

$NonCompliantDevices |
    Select-Object `
        DeviceName,
        OperatingSystem,
        UserPrincipalName,
        ComplianceState,
        LastSyncDateTime |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Non-compliant device report created." -ForegroundColor Green
Write-Host "Devices found: $($NonCompliantDevices.Count)"
Write-Host "File: $OutputFile"