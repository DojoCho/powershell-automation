<#
.SYNOPSIS
Displays disk usage for local fixed drives.

.DESCRIPTION
Reports total, used and free space for each local fixed disk, including
the percentage of free space remaining.

.EXAMPLE
.\Get-DiskUsage.ps1

.NOTES
The script performs read-only operations.
#>

[CmdletBinding()]
param()

Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType = 3" |
    Select-Object `
        @{ Name = "Drive";      Expression = { $_.DeviceID } },
        @{ Name = "Label";      Expression = { $_.VolumeName } },
        @{ Name = "TotalGB";    Expression = { [math]::Round($_.Size / 1GB, 2) } },
        @{ Name = "UsedGB";     Expression = { [math]::Round(($_.Size - $_.FreeSpace) / 1GB, 2) } },
        @{ Name = "FreeGB";     Expression = { [math]::Round($_.FreeSpace / 1GB, 2) } },
        @{ Name = "FreePercent"; Expression = {
            if ($_.Size -gt 0) { [math]::Round(($_.FreeSpace / $_.Size) * 100, 1) } else { 0 }
        } } |
    Sort-Object Drive |
    Format-Table -AutoSize
