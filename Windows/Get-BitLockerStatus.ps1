<#
.SYNOPSIS
Reports BitLocker protection status for local volumes.

.DESCRIPTION
Returns the BitLocker protection status, encryption method and encryption
percentage for each volume on the local computer.

.EXAMPLE
.\Get-BitLockerStatus.ps1

.NOTES
Requires the BitLocker PowerShell module, which is present on supported
Windows client and server editions.

Full volume details require an elevated session.
The script performs read-only operations and never modifies encryption
settings or retrieves recovery keys.
#>

[CmdletBinding()]
param()

if (-not (Get-Command -Name Get-BitLockerVolume -ErrorAction SilentlyContinue)) {
    Write-Host "The BitLocker module is not available on this system." -ForegroundColor Yellow
    Write-Host "BitLocker is not supported on all Windows editions." -ForegroundColor Yellow
    exit 1
}

try {
    $Volumes = Get-BitLockerVolume -ErrorAction Stop
}
catch {
    Write-Host "Could not read BitLocker status: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Try running this script from an elevated PowerShell session." -ForegroundColor Yellow
    exit 1
}

$Volumes |
    Select-Object `
        MountPoint,
        VolumeType,
        ProtectionStatus,
        VolumeStatus,
        EncryptionMethod,
        EncryptionPercentage,
        @{ Name = "SizeGB"; Expression = { [math]::Round($_.CapacityGB, 2) } } |
    Sort-Object MountPoint |
    Format-Table -AutoSize
