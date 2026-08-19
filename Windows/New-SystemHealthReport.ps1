<#
.SYNOPSIS
Generates a system health report for the local computer.

.DESCRIPTION
Collects operating system, uptime, memory, disk and service information
and presents it as a readable health summary. Disks below a configurable
free space threshold are flagged.

Optionally exports the disk detail to CSV.

.PARAMETER LowDiskThresholdPercent
Free space percentage below which a disk is flagged as low.

.PARAMETER ExportCsv
Export the disk section to a CSV file next to the script.

.EXAMPLE
.\New-SystemHealthReport.ps1

.EXAMPLE
.\New-SystemHealthReport.ps1 -LowDiskThresholdPercent 20 -ExportCsv

.NOTES
The script performs read-only operations.
#>

[CmdletBinding()]
param(
    [ValidateRange(1, 99)]
    [int]$LowDiskThresholdPercent = 15,

    [switch]$ExportCsv
)

$Os       = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
$Computer = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
$Cpu      = Get-CimInstance -ClassName Win32_Processor -ErrorAction Stop | Select-Object -First 1
$Disks    = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType = 3" -ErrorAction Stop

$Uptime      = (Get-Date) - $Os.LastBootUpTime
$MemoryTotal = [math]::Round($Computer.TotalPhysicalMemory / 1GB, 2)
$MemoryFree  = [math]::Round($Os.FreePhysicalMemory * 1KB / 1GB, 2)
$MemoryUsed  = [math]::Round($MemoryTotal - $MemoryFree, 2)
$MemoryPct   = if ($MemoryTotal -gt 0) { [math]::Round(($MemoryUsed / $MemoryTotal) * 100, 1) } else { 0 }

Write-Host ""
Write-Host "===== SYSTEM HEALTH REPORT =====" -ForegroundColor Cyan
Write-Host "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host ""

Write-Host "-- System --" -ForegroundColor Cyan
Write-Host "Computer   : $($Computer.Name)"
Write-Host "Model      : $($Computer.Manufacturer) $($Computer.Model)"
Write-Host "OS         : $($Os.Caption) (build $($Os.BuildNumber))"
Write-Host "CPU        : $($Cpu.Name)"
Write-Host "Uptime     : $($Uptime.Days)d $($Uptime.Hours)h $($Uptime.Minutes)m"
Write-Host "Last boot  : $($Os.LastBootUpTime)"
Write-Host ""

Write-Host "-- Memory --" -ForegroundColor Cyan
Write-Host "Total : $MemoryTotal GB"
Write-Host "Used  : $MemoryUsed GB ($MemoryPct%)"
Write-Host "Free  : $MemoryFree GB"
Write-Host ""

Write-Host "-- Disks --" -ForegroundColor Cyan

$DiskReport = foreach ($Disk in $Disks) {

    $FreePercent = if ($Disk.Size -gt 0) {
        [math]::Round(($Disk.FreeSpace / $Disk.Size) * 100, 1)
    } else { 0 }

    $Status = if ($FreePercent -lt $LowDiskThresholdPercent) { "LOW" } else { "OK" }

    [PSCustomObject]@{
        Drive       = $Disk.DeviceID
        Label       = $Disk.VolumeName
        TotalGB     = [math]::Round($Disk.Size / 1GB, 2)
        FreeGB      = [math]::Round($Disk.FreeSpace / 1GB, 2)
        FreePercent = $FreePercent
        Status      = $Status
    }
}

$DiskReport | Format-Table -AutoSize

$LowDisks = @($DiskReport | Where-Object { $_.Status -eq "LOW" })

Write-Host "-- Summary --" -ForegroundColor Cyan

if ($LowDisks.Count -gt 0) {
    Write-Host "Disks below $LowDiskThresholdPercent% free: $($LowDisks.Drive -join ', ')" -ForegroundColor Yellow
}
else {
    Write-Host "All disks are above the $LowDiskThresholdPercent% free space threshold." -ForegroundColor Green
}

if ($ExportCsv) {
    $OutputFile = Join-Path $PSScriptRoot "SystemHealth-Disks.csv"
    $DiskReport | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8
    Write-Host "Disk detail exported to: $OutputFile"
}

Write-Host ""
