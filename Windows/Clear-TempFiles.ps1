<#
.SYNOPSIS
Removes temporary files and reports how much space was reclaimed.

.DESCRIPTION
Deletes files from the current user's temporary folder and, when running
elevated, from the Windows temporary folder.

Files that are locked by running processes are skipped and counted rather
than silently ignored, so the summary reflects what was actually removed.

.PARAMETER IncludeWindowsTemp
Also clean C:\Windows\Temp. Requires an elevated session.

.EXAMPLE
.\Clear-TempFiles.ps1 -WhatIf

.EXAMPLE
.\Clear-TempFiles.ps1 -IncludeWindowsTemp

.NOTES
This script deletes data. Run it with -WhatIf first to review the scope.
#>

[CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Medium")]
param(
    [switch]$IncludeWindowsTemp
)

$IsElevated = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$Targets = @($env:TEMP)

if ($IncludeWindowsTemp) {
    if ($IsElevated) {
        $Targets += Join-Path $env:SystemRoot "Temp"
    }
    else {
        Write-Warning "Skipping the Windows temp folder: an elevated session is required."
    }
}

$TotalRemoved = 0
$TotalSkipped = 0
$TotalBytes   = 0

foreach ($Folder in $Targets) {

    if (-not (Test-Path -Path $Folder)) {
        Write-Warning "Folder not found: $Folder"
        continue
    }

    Write-Host "Cleaning $Folder..." -ForegroundColor Cyan

    $Items = Get-ChildItem -Path $Folder -Force -ErrorAction SilentlyContinue

    foreach ($Item in $Items) {

        if (-not $PSCmdlet.ShouldProcess($Item.FullName, "Remove")) {
            continue
        }

        $Size = 0

        if ($Item.PSIsContainer) {
            $Size = (Get-ChildItem -Path $Item.FullName -Recurse -File -Force -ErrorAction SilentlyContinue |
                Measure-Object -Property Length -Sum).Sum
        }
        else {
            $Size = $Item.Length
        }

        try {
            Remove-Item -Path $Item.FullName -Force -Recurse -ErrorAction Stop
            $TotalRemoved++
            $TotalBytes += ($Size | ForEach-Object { if ($_) { $_ } else { 0 } })
        }
        catch {
            # Files in use by a running process cannot be deleted. This is expected.
            $TotalSkipped++
        }
    }
}

$FreedMb = [math]::Round($TotalBytes / 1MB, 2)

Write-Host ""

if ($TotalRemoved -gt 0) {
    Write-Host "Temporary file cleanup finished." -ForegroundColor Green
}
else {
    Write-Host "Temporary file cleanup finished. Nothing was removed." -ForegroundColor Yellow
}

Write-Host "Items removed  : $TotalRemoved"
Write-Host "Items in use   : $TotalSkipped (skipped)"
Write-Host "Space reclaimed: $FreedMb MB"
