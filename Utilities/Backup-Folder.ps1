<#
.SYNOPSIS
Creates a timestamped backup copy of a folder.

.DESCRIPTION
Copies the contents of a source folder into a timestamped subfolder of the
destination path, so repeated runs do not overwrite previous backups.

.PARAMETER Source
Path of the folder to back up.

.PARAMETER Destination
Root path where the timestamped backup folder is created.

.PARAMETER Name
Optional label used in the backup folder name. Defaults to the source folder name.

.EXAMPLE
.\Backup-Folder.ps1 -Source "C:\Data\Reports" -Destination "D:\Backups"

.NOTES
The script only reads from the source and writes to the destination.
It never deletes existing data.
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidateScript({
        if (Test-Path -Path $_ -PathType Container) { $true }
        else { throw "Source folder not found: $_" }
    })]
    [string]$Source,

    [Parameter(Mandatory)]
    [string]$Destination,

    [string]$Name
)

$ErrorActionPreference = "Stop"

if (-not $Name) {
    $Name = Split-Path -Path $Source -Leaf
}

$Timestamp  = Get-Date -Format "yyyy-MM-dd_HHmmss"
$BackupPath = Join-Path $Destination "$Name`_$Timestamp"

try {
    if (-not (Test-Path -Path $Destination)) {
        if ($PSCmdlet.ShouldProcess($Destination, "Create destination folder")) {
            New-Item -Path $Destination -ItemType Directory -Force | Out-Null
        }
    }

    if ($PSCmdlet.ShouldProcess($Source, "Back up to $BackupPath")) {

        Write-Host "Backing up..." -ForegroundColor Cyan
        Write-Host "Source      : $Source"
        Write-Host "Destination : $BackupPath"

        Copy-Item -Path $Source -Destination $BackupPath -Recurse -Force

        $Items = Get-ChildItem -Path $BackupPath -Recurse -File
        $SizeMb = [math]::Round((($Items | Measure-Object -Property Length -Sum).Sum / 1MB), 2)

        Write-Host ""
        Write-Host "Backup completed." -ForegroundColor Green
        Write-Host "Files copied : $($Items.Count)"
        Write-Host "Total size   : $SizeMb MB"
        Write-Host "Location     : $BackupPath"
    }
}
catch {
    Write-Host ""
    Write-Host "Backup failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
