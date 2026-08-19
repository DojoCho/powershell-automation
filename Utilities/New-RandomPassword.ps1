<#
.SYNOPSIS
Generates a cryptographically secure random password.

.DESCRIPTION
Creates a random password using the .NET cryptographic random number
generator. The generated password is guaranteed to contain at least one
lowercase letter, one uppercase letter, one digit, and one symbol.

.PARAMETER Length
Length of the generated password. Minimum 8, maximum 128.

.PARAMETER Count
Number of passwords to generate.

.EXAMPLE
.\New-RandomPassword.ps1

.EXAMPLE
.\New-RandomPassword.ps1 -Length 24 -Count 5

.NOTES
Uses System.Security.Cryptography.RandomNumberGenerator rather than
Get-Random, which is not suitable for security-sensitive values.
#>

[CmdletBinding()]
param(
    [ValidateRange(8, 128)]
    [int]$Length = 16,

    [ValidateRange(1, 100)]
    [int]$Count = 1
)

$Lower   = "abcdefghijkmnopqrstuvwxyz"      # excludes 'l'
$Upper   = "ABCDEFGHJKLMNPQRSTUVWXYZ"       # excludes 'I' and 'O'
$Digit   = "23456789"                       # excludes '0' and '1'
$Symbol  = "!@#$%^&*()-_=+[]{}"
$AllSets = @($Lower, $Upper, $Digit, $Symbol)
$AllChars = -join $AllSets

# RandomNumberGenerator.Create() is available on both Windows PowerShell 5.1
# (.NET Framework) and PowerShell 7+ (.NET). The static Fill() method is not.
$Rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()

function Get-SecureRandomIndex {
    param([int]$MaxExclusive)

    # Rejection sampling keeps the distribution uniform.
    $Limit = [int]::MaxValue - ([int]::MaxValue % $MaxExclusive)
    $Bytes = New-Object byte[] 4

    do {
        $Rng.GetBytes($Bytes)
        $Value = [System.BitConverter]::ToInt32($Bytes, 0) -band [int]::MaxValue
    } while ($Value -ge $Limit)

    return $Value % $MaxExclusive
}

for ($i = 0; $i -lt $Count; $i++) {

    # Guarantee one character from every set, then fill the remainder.
    $Chars = [System.Collections.Generic.List[char]]::new()

    foreach ($Set in $AllSets) {
        $Chars.Add($Set[(Get-SecureRandomIndex -MaxExclusive $Set.Length)])
    }

    while ($Chars.Count -lt $Length) {
        $Chars.Add($AllChars[(Get-SecureRandomIndex -MaxExclusive $AllChars.Length)])
    }

    # Fisher-Yates shuffle so the guaranteed characters are not always first.
    for ($j = $Chars.Count - 1; $j -gt 0; $j--) {
        $k = Get-SecureRandomIndex -MaxExclusive ($j + 1)
        $Temp = $Chars[$j]
        $Chars[$j] = $Chars[$k]
        $Chars[$k] = $Temp
    }

    Write-Output (-join $Chars)
}

$Rng.Dispose()
