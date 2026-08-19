<#
.SYNOPSIS
Exports recent Windows event log entries to CSV.

.DESCRIPTION
Retrieves the most recent entries from a Windows event log and exports
them to a CSV report next to the script.

Uses Get-WinEvent, which is available in both Windows PowerShell 5.1 and
PowerShell 7+. The older Get-EventLog cmdlet was removed in PowerShell 6
and later.

.PARAMETER LogName
Name of the event log to export. Defaults to System.

.PARAMETER MaxEvents
Number of most recent events to export.

.PARAMETER Level
Optional severity filter: Critical, Error, Warning, Information.

.EXAMPLE
.\Export-EventLogs.ps1

.EXAMPLE
.\Export-EventLogs.ps1 -LogName Application -MaxEvents 500 -Level Error

.NOTES
Exporting the Security log requires an elevated session.
The script performs read-only operations.
#>

[CmdletBinding()]
param(
    [string]$LogName = "System",

    [ValidateRange(1, 100000)]
    [int]$MaxEvents = 100,

    [ValidateSet("Critical", "Error", "Warning", "Information")]
    [string[]]$Level
)

$OutputFile = Join-Path $PSScriptRoot "EventLog-$LogName.csv"

$LevelMap = @{
    Critical    = 1
    Error       = 2
    Warning     = 3
    Information = 4
}

$FilterHashtable = @{ LogName = $LogName }

if ($Level) {
    $FilterHashtable["Level"] = $Level | ForEach-Object { $LevelMap[$_] }
}

Write-Host "Retrieving events from the $LogName log..." -ForegroundColor Cyan

try {
    $Events = Get-WinEvent -FilterHashtable $FilterHashtable -MaxEvents $MaxEvents -ErrorAction Stop
}
catch {
    Write-Host ""
    Write-Host "Could not read the $LogName log: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Reading some logs, such as Security, requires an elevated session." -ForegroundColor Yellow
    exit 1
}

$Events |
    Select-Object `
        TimeCreated,
        LogName,
        LevelDisplayName,
        Id,
        ProviderName,
        MachineName,
        Message |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Event log report created." -ForegroundColor Green
Write-Host "Events exported: $($Events.Count)"
Write-Host "File: $OutputFile"
