<#
.SYNOPSIS
Creates a backup of a folder.
#>

param(
    [string]$Source,
    [string]$Destination
)

Copy-Item $Source -Destination $Destination -Recurse -Force

Write-Host "Backup completed."