# Windows PowerShell Scripts

PowerShell scripts for Windows endpoint administration, inventory, diagnostics and maintenance.

## Requirements

- Windows PowerShell 5.1 or PowerShell 7+
- Some scripts require an elevated session (see the table below)

## Scripts

| Script | Description | Elevation | Modifies system |
|---|---|---|---|
| `Clear-TempFiles.ps1` | Removes temporary files and reports space reclaimed | Only for `-IncludeWindowsTemp` | **Yes — deletes files** |
| `Export-EventLogs.ps1` | Exports recent event log entries to CSV | Only for the Security log | No |
| `Export-InstalledDrivers.ps1` | Exports signed device drivers to CSV | No | No |
| `Get-BitLockerStatus.ps1` | Reports BitLocker protection status per volume | Yes | No |
| `Get-InstalledSoftware.ps1` | Reports installed applications from all uninstall keys | No | No |
| `Get-SystemInfo.ps1` | Returns hardware and OS details as an object | No | No |
| `New-SystemHealthReport.ps1` | Uptime, memory and disk health summary | No | No |
| `Restart-StoppedServices.ps1` | Starts stopped automatic services | Yes | **Yes — changes services** |

## Usage

```powershell
Get-Help .\Get-InstalledSoftware.ps1 -Full
```

Examples:

```powershell
# Full software inventory, including 32-bit and per-user installations
.\Get-InstalledSoftware.ps1

# Filter the inventory
.\Get-InstalledSoftware.ps1 -Name "*Microsoft*"

# System details, ready to export
.\Get-SystemInfo.ps1 | Export-Csv .\SystemInfo.csv -NoTypeInformation

# Health summary with a custom low-disk threshold
.\New-SystemHealthReport.ps1 -LowDiskThresholdPercent 20

# Export only errors and warnings from the Application log
.\Export-EventLogs.ps1 -LogName Application -MaxEvents 500 -Level Error,Warning

# Review temp cleanup before running it
.\Clear-TempFiles.ps1 -WhatIf
```

## Software Inventory

`Get-InstalledSoftware.ps1` reads all three uninstall registry locations:

```text
HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall
HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall
HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall
```

Reading only the first location, as many inventory snippets do, misses every
32-bit and per-user installation. On a typical workstation that is a large
share of the installed software.

## PowerShell 7 Compatibility

`Export-EventLogs.ps1` uses `Get-WinEvent` rather than `Get-EventLog`, which was
removed in PowerShell 6 and later. All scripts in this directory run on both
Windows PowerShell 5.1 and PowerShell 7+.

## Safety

Two scripts in this directory change system state:

- `Clear-TempFiles.ps1` deletes files
- `Restart-StoppedServices.ps1` starts services

Both support `-WhatIf` and `-Confirm`. Run them with `-WhatIf` first.

Not every stopped automatic service indicates a problem — many are stopped by
design. Review the reported list before starting services on a production
machine.

The remaining scripts are read-only.
