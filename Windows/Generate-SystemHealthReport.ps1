<#
.SYNOPSIS
Generates a basic Windows system health report.
#>

$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

Write-Host "===== SYSTEM HEALTH REPORT =====" -ForegroundColor Cyan
Write-Host ""

Write-Host "Computer :" $env:COMPUTERNAME
Write-Host "OS       :" $os.Caption
Write-Host "CPU      :" $cpu.Name
Write-Host ""

foreach ($d in $disk) {
    $free = [math]::Round($d.FreeSpace / 1GB,2)
    $size = [math]::Round($d.Size / 1GB,2)

    Write-Host "$($d.DeviceID)  $free GB free of $size GB"
}