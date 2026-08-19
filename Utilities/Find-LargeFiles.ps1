<#
.SYNOPSIS
Finds files larger than a specified size.

.DESCRIPTION
Recursively searches a path for files above a minimum size and reports
them sorted from largest to smallest. Useful for tracking down disk space
consumption during IT support work.

.PARAMETER Path
Root path to search. Defaults to the system drive.

.PARAMETER MinimumSizeMb
Minimum file size in megabytes.

.PARAMETER Top
Maximum number of results to return.

.EXAMPLE
.\Find-LargeFiles.ps1

.EXAMPLE
.\Find-LargeFiles.ps1 -Path "D:\Shares" -MinimumSizeMb 250 -Top 50

.NOTES
Scanning an entire drive can take several minutes.
The script performs read-only operations.
#>

[CmdletBinding()]
param(
    [string]$Path = $env:SystemDrive + "\",

    [ValidateRange(1, 1048576)]
    [int]$MinimumSizeMb = 500,

    [ValidateRange(1, 10000)]
    [int]$Top = 25
)

if (-not (Test-Path -Path $Path)) {
    Write-Host "Path not found: $Path" -ForegroundColor Red
    exit 1
}

$MinimumBytes = $MinimumSizeMb * 1MB

Write-Host "Searching for files larger than $MinimumSizeMb MB..." -ForegroundColor Cyan
Write-Host "Path: $Path"
Write-Host "This may take several minutes."

$Files = Get-ChildItem -Path $Path -File -Recurse -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.Length -gt $MinimumBytes }

if (-not $Files) {
    Write-Host ""
    Write-Host "No files larger than $MinimumSizeMb MB were found." -ForegroundColor Green
    return
}

$Files |
    Sort-Object Length -Descending |
    Select-Object -First $Top -Property `
        @{ Name = "SizeGB";       Expression = { [math]::Round($_.Length / 1GB, 2) } },
        @{ Name = "LastModified"; Expression = { $_.LastWriteTime } },
        FullName |
    Format-Table -AutoSize

Write-Host "Files matched: $($Files.Count) (showing top $Top)"
