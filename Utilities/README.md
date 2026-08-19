# Utility PowerShell Scripts

General-purpose PowerShell utilities for IT support, file management, troubleshooting and day-to-day automation.

## Requirements

- Windows PowerShell 5.1 or PowerShell 7+
- No additional modules required

## Scripts

| Script | Description | Modifies system |
|---|---|---|
| `Backup-Folder.ps1` | Copies a folder into a timestamped backup directory | Writes only |
| `Find-LargeFiles.ps1` | Finds files above a size threshold, sorted largest first | No |
| `Get-DiskUsage.ps1` | Reports total, used and free space for local fixed disks | No |
| `New-RandomPassword.ps1` | Generates cryptographically secure random passwords | No |
| `Remove-OldFiles.ps1` | Deletes files older than a given number of days | **Yes — deletes files** |
| `Test-NetworkConnection.ps1` | Tests connectivity to one or more hosts | No |

## Usage

Every script supports comment-based help:

```powershell
Get-Help .\Remove-OldFiles.ps1 -Full
```

Examples:

```powershell
# Generate five 24-character passwords
.\New-RandomPassword.ps1 -Length 24 -Count 5

# Review what would be deleted, without deleting anything
.\Remove-OldFiles.ps1 -Path "D:\Logs" -Days 30 -WhatIf

# Then run it for real
.\Remove-OldFiles.ps1 -Path "D:\Logs" -Days 30

# Back up a folder
.\Backup-Folder.ps1 -Source "C:\Data\Reports" -Destination "D:\Backups"

# Find files over 250 MB on a specific volume
.\Find-LargeFiles.ps1 -Path "D:\Shares" -MinimumSizeMb 250

# Test connectivity to specific hosts
.\Test-NetworkConnection.ps1 -TargetHost "dc01.contoso.com","8.8.8.8"
```

## Password Generation

`New-RandomPassword.ps1` uses `System.Security.Cryptography.RandomNumberGenerator`
rather than `Get-Random`, which is not suitable for security-sensitive values.

Generated passwords are guaranteed to contain at least one lowercase letter, one
uppercase letter, one digit and one symbol. Visually ambiguous characters
(`l`, `I`, `O`, `0`, `1`) are excluded to reduce transcription errors during
support calls.

## Safety

`Remove-OldFiles.ps1` deletes data. It supports `-WhatIf` and `-Confirm` and
prompts before removing files by default.

Always run it with `-WhatIf` first to review the file list.

The remaining scripts either read data or write to a destination you specify.
