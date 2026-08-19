<#
.SYNOPSIS
Exports installed device drivers to CSV.

.DESCRIPTION
Retrieves signed device drivers through CIM and exports driver version,
provider and device information to a CSV report next to the script.

Win32_PnPSignedDriver is used rather than Get-WindowsDriver because it
does not require an elevated session.

.PARAMETER ProviderName
Optional filter. Returns only drivers from providers matching this
wildcard pattern.

.EXAMPLE
.\Export-InstalledDrivers.ps1

.EXAMPLE
.\Export-InstalledDrivers.ps1 -ProviderName "*Intel*"

.NOTES
The script performs read-only operations.
#>

[CmdletBinding()]
param(
    [string]$ProviderName
)

$OutputFile = Join-Path $PSScriptRoot "Installed-Drivers.csv"

Write-Host "Retrieving installed drivers..." -ForegroundColor Cyan

$Drivers = Get-CimInstance -ClassName Win32_PnPSignedDriver -ErrorAction Stop |
    Where-Object { $_.DeviceName }

if ($ProviderName) {
    $Drivers = $Drivers | Where-Object { $_.DriverProviderName -like $ProviderName }
}

$Drivers |
    Select-Object `
        DeviceName,
        DriverProviderName,
        DriverVersion,
        @{ Name = "DriverDate"; Expression = { $_.DriverDate } },
        DeviceClass,
        IsSigned |
    Sort-Object DeviceName |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Driver report created." -ForegroundColor Green
Write-Host "Drivers exported: $($Drivers.Count)"
Write-Host "File: $OutputFile"
