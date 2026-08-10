<#
.SYNOPSIS
Attempts to start automatic services that are currently stopped.
#>

Get-Service |
Where-Object {
    $_.StartType -eq "Automatic" -and $_.Status -eq "Stopped"
} |
Start-Service