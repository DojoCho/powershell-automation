<#
.SYNOPSIS
Reports software installed on the local computer.

.DESCRIPTION
Reads the Windows uninstall registry keys and returns installed applications.

All three uninstall locations are queried so that 64-bit, 32-bit and
per-user installations are included:

  HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall
  HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall
  HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall

.PARAMETER Name
Optional filter. Returns only applications whose display name matches
this wildcard pattern.

.PARAMETER IncludeUpdates
Include system components and Windows update entries, which are hidden
by default because they add a large amount of noise.

.EXAMPLE
.\Get-InstalledSoftware.ps1

.EXAMPLE
.\Get-InstalledSoftware.ps1 -Name "*Microsoft*"

.NOTES
The script performs read-only operations.
#>

[CmdletBinding()]
param(
    [string]$Name,

    [switch]$IncludeUpdates
)

$UninstallPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

$Software = foreach ($Path in $UninstallPaths) {

    $Scope = if ($Path -like "HKCU:*") { "User" }
             elseif ($Path -like "*WOW6432Node*") { "Machine (32-bit)" }
             else { "Machine (64-bit)" }

    Get-ItemProperty -Path $Path -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName } |
        Where-Object { $IncludeUpdates -or -not $_.SystemComponent } |
        Where-Object { $IncludeUpdates -or -not $_.ParentKeyName } |
        ForEach-Object {

            [PSCustomObject]@{
                DisplayName    = $_.DisplayName
                DisplayVersion = $_.DisplayVersion
                Publisher      = $_.Publisher
                InstallDate    = $_.InstallDate
                Scope          = $Scope
            }
        }
}

if ($Name) {
    $Software = $Software | Where-Object { $_.DisplayName -like $Name }
}

$Software |
    Sort-Object DisplayName, DisplayVersion -Unique |
    Sort-Object DisplayName
