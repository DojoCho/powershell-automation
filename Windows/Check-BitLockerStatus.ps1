<#
.SYNOPSIS
Displays BitLocker protection status for all volumes.
#>

Get-BitLockerVolume |
Select-Object MountPoint, ProtectionStatus, VolumeStatus, EncryptionPercentage |
Format-Table -AutoSize