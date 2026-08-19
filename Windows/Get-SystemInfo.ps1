<#
.SYNOPSIS
Returns hardware and operating system information for the local computer.

.DESCRIPTION
Collects computer, operating system and BIOS details through CIM and
returns them as an object so the result can be piped, exported or
formatted as needed.

.EXAMPLE
.\Get-SystemInfo.ps1

.EXAMPLE
.\Get-SystemInfo.ps1 | Export-Csv -Path .\SystemInfo.csv -NoTypeInformation

.NOTES
The script performs read-only operations.
#>

[CmdletBinding()]
param()

$Computer = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
$Os       = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
$Bios     = Get-CimInstance -ClassName Win32_BIOS -ErrorAction Stop
$Cpu      = Get-CimInstance -ClassName Win32_Processor -ErrorAction Stop | Select-Object -First 1

[PSCustomObject]@{
    ComputerName  = $Computer.Name
    Manufacturer  = $Computer.Manufacturer
    Model         = $Computer.Model
    SerialNumber  = $Bios.SerialNumber
    BiosVersion   = $Bios.SMBIOSBIOSVersion
    Processor     = $Cpu.Name
    LogicalCores  = $Computer.NumberOfLogicalProcessors
    MemoryGB      = [math]::Round($Computer.TotalPhysicalMemory / 1GB, 2)
    OperatingSystem = $Os.Caption
    OsVersion     = $Os.Version
    OsBuild       = $Os.BuildNumber
    OsArchitecture = $Os.OSArchitecture
    InstallDate   = $Os.InstallDate
    LastBootTime  = $Os.LastBootUpTime
    Domain        = $Computer.Domain
    CurrentUser   = $Computer.UserName
}
