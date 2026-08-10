<#
.SYNOPSIS
Generates a secure random password.
#>

param(
    [int]$Length = 16
)

$characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()'
$password = -join (1..$Length | ForEach-Object {
    $characters[(Get-Random -Maximum $characters.Length)]
})

Write-Host $password