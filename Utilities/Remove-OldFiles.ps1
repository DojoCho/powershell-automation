<#
.SYNOPSIS
Removes files older than a specified number of days.

.DESCRIPTION
Finds files in a folder whose last write time is older than the given
threshold and deletes them. Supports -WhatIf so the affected files can be
reviewed before anything is removed.

Only files are deleted. Folders are left in place.

.PARAMETER Path
Folder to clean up.

.PARAMETER Days
Age threshold in days. Files older than this are removed.

.PARAMETER Recurse
Include subfolders.

.EXAMPLE
.\Remove-OldFiles.ps1 -Path "D:\Logs" -Days 30 -WhatIf

.EXAMPLE
.\Remove-OldFiles.ps1 -Path "D:\Logs" -Days 30 -Recurse

.NOTES
This script deletes data. Always run it with -WhatIf first.
#>

[CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High")]
param(
    [Parameter(Mandatory)]
    [ValidateScript({
        if (Test-Path -Path $_ -PathType Container) { $true }
        else { throw "Folder not found: $_" }
    })]
    [string]$Path,

    [Parameter(Mandatory)]
    [ValidateRange(1, 3650)]
    [int]$Days,

    [switch]$Recurse
)

$Cutoff = (Get-Date).AddDays(-$Days)

Write-Host "Scanning for files older than $Days days..." -ForegroundColor Cyan
Write-Host "Path   : $Path"
Write-Host "Cutoff : $($Cutoff.ToString('yyyy-MM-dd HH:mm'))"

$OldFiles = Get-ChildItem -Path $Path -File -Recurse:$Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -lt $Cutoff }

if (-not $OldFiles) {
    Write-Host ""
    Write-Host "No files older than $Days days were found." -ForegroundColor Green
    return
}

$TotalMb = [math]::Round((($OldFiles | Measure-Object -Property Length -Sum).Sum / 1MB), 2)

Write-Host ""
Write-Host "Files matched : $($OldFiles.Count)"
Write-Host "Space to free : $TotalMb MB"
Write-Host ""

$Removed = 0
$Failed  = 0

foreach ($File in $OldFiles) {
    if ($PSCmdlet.ShouldProcess($File.FullName, "Remove file")) {
        try {
            Remove-Item -Path $File.FullName -Force -ErrorAction Stop
            $Removed++
        }
        catch {
            Write-Warning "Could not remove $($File.FullName): $($_.Exception.Message)"
            $Failed++
        }
    }
}

Write-Host ""
Write-Host "Cleanup finished." -ForegroundColor Green
Write-Host "Files removed : $Removed"
Write-Host "Failed        : $Failed"
