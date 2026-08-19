<#
.SYNOPSIS
Finds non-compliant devices in Microsoft Intune.

.DESCRIPTION
Retrieves Intune managed devices and reports those in a non-compliant
state.

Intune reports several compliance states. Only states that represent an
actual compliance problem are included by default:

  noncompliant, conflict, error

Devices in the inGracePeriod, unknown, notApplicable and configManager
states are excluded unless explicitly requested, because they do not
indicate a policy failure.

.PARAMETER IncludeGracePeriod
Also include devices in the inGracePeriod state.

.PARAMETER IncludeUnknown
Also include devices in the unknown or notApplicable states.

.EXAMPLE
.\Find-NonCompliantDevices.ps1

.EXAMPLE
.\Find-NonCompliantDevices.ps1 -IncludeGracePeriod

.NOTES
Requires the Microsoft.Graph.DeviceManagement module.
Requires the DeviceManagementManagedDevices.Read.All permission.

The script does not modify devices or policies.
#>

[CmdletBinding()]
param(
    [switch]$IncludeGracePeriod,

    [switch]$IncludeUnknown
)

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

$TargetStates = @("noncompliant", "conflict", "error")

if ($IncludeGracePeriod) { $TargetStates += "inGracePeriod" }
if ($IncludeUnknown)     { $TargetStates += @("unknown", "notApplicable") }

Write-Host "Checking Intune device compliance..." -ForegroundColor Cyan
Write-Host "States reported: $($TargetStates -join ', ')"

$Devices = Get-MgDeviceManagementManagedDevice `
    -All `
    -Property "deviceName,operatingSystem,osVersion,userPrincipalName,complianceState,lastSyncDateTime"

$NonCompliantDevices = $Devices |
    Where-Object { $TargetStates -contains $_.ComplianceState }

if (-not $NonCompliantDevices) {
    Write-Host ""
    Write-Host "No devices matched the selected compliance states." -ForegroundColor Green
    Write-Host "Devices checked: $($Devices.Count)"
    return
}

$NonCompliantDevices |
    Select-Object `
        DeviceName,
        OperatingSystem,
        OsVersion,
        UserPrincipalName,
        ComplianceState,
        LastSyncDateTime |
    Sort-Object ComplianceState, DeviceName |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Non-compliant device report created." -ForegroundColor Green
Write-Host "Devices checked : $($Devices.Count)"
Write-Host "Devices reported: $($NonCompliantDevices.Count)"
Write-Host "File: $OutputFile"
