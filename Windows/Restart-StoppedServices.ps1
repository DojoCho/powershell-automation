<#
.SYNOPSIS
Starts automatic services that are currently stopped.

.DESCRIPTION
Finds services configured to start automatically that are not running and
attempts to start them.

By default the script only reports what it found. Use -Confirm:$false or
respond to the prompts to actually start services.

Delayed-start services are excluded by default, because they are commonly
stopped for a period after boot by design.

.PARAMETER ExcludeService
Service names to skip.

.PARAMETER IncludeDelayedStart
Also attempt to start delayed-start automatic services.

.EXAMPLE
.\Restart-StoppedServices.ps1 -WhatIf

.EXAMPLE
.\Restart-StoppedServices.ps1 -ExcludeService "gupdate","edgeupdate"

.NOTES
This script changes system state and requires an elevated session.
Not every stopped automatic service indicates a problem. Review the list
before starting services on a production machine.
#>

[CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High")]
param(
    [string[]]$ExcludeService = @(),

    [switch]$IncludeDelayedStart
)

$IsElevated = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsElevated) {
    Write-Host "This script requires an elevated PowerShell session." -ForegroundColor Yellow
    exit 1
}

Write-Host "Checking automatic services..." -ForegroundColor Cyan

$Candidates = Get-CimInstance -ClassName Win32_Service -ErrorAction Stop |
    Where-Object {
        $_.StartMode -eq "Auto" -and
        $_.State     -eq "Stopped" -and
        $ExcludeService -notcontains $_.Name
    }

if (-not $IncludeDelayedStart) {
    $Candidates = $Candidates | Where-Object { -not $_.DelayedAutoStart }
}

if (-not $Candidates) {
    Write-Host ""
    Write-Host "All automatic services are running." -ForegroundColor Green
    return
}

Write-Host ""
Write-Host "Stopped automatic services found: $($Candidates.Count)"
Write-Host ""

$Candidates |
    Select-Object Name, DisplayName, StartMode, State |
    Format-Table -AutoSize

$Started = 0
$Failed  = 0

foreach ($Service in $Candidates) {

    if ($PSCmdlet.ShouldProcess($Service.DisplayName, "Start service")) {
        try {
            Start-Service -Name $Service.Name -ErrorAction Stop
            Write-Host "Started: $($Service.DisplayName)" -ForegroundColor Green
            $Started++
        }
        catch {
            Write-Warning "Could not start $($Service.DisplayName): $($_.Exception.Message)"
            $Failed++
        }
    }
}

Write-Host ""
Write-Host "Service check finished." -ForegroundColor Green
Write-Host "Started : $Started"
Write-Host "Failed  : $Failed"
