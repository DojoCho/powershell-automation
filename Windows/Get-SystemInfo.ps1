$computer = Get-CimInstance Win32_ComputerSystem
$os = Get-CimInstance Win32_OperatingSystem
$bios = Get-CimInstance Win32_BIOS

Write-Host ""
Write-Host "===== SYSTEM INFORMATION =====" -ForegroundColor Cyan
Write-Host ""

Write-Host "Computer Name :" $computer.Name
Write-Host "Manufacturer  :" $computer.Manufacturer
Write-Host "Model         :" $computer.Model
Write-Host "OS            :" $os.Caption
Write-Host "Version       :" $os.Version
Write-Host "Serial Number :" $bios.SerialNumber
Write-Host "Memory (GB)   :" ([math]::Round($computer.TotalPhysicalMemory / 1GB,2))
