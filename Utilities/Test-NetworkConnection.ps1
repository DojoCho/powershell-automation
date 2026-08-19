<#
.SYNOPSIS
Tests network connectivity to a list of target hosts.

.DESCRIPTION
Sends ICMP echo requests to each target host and reports whether the
host responded, along with the average round-trip time when available.

.PARAMETER TargetHost
One or more host names or IP addresses to test.
Defaults to a small set of well-known public endpoints.

.PARAMETER Count
Number of echo requests to send per host.

.EXAMPLE
.\Test-NetworkConnection.ps1

.EXAMPLE
.\Test-NetworkConnection.ps1 -TargetHost "dc01.contoso.com","8.8.8.8" -Count 4

.NOTES
The script performs read-only operations.
#>

[CmdletBinding()]
param(
    [string[]]$TargetHost = @("google.com", "github.com", "1.1.1.1"),

    [ValidateRange(1, 10)]
    [int]$Count = 2
)

$Results = foreach ($Target in $TargetHost) {

    Write-Verbose "Testing $Target..."

    $Replies = $null

    try {
        $Replies = Test-Connection -ComputerName $Target -Count $Count -ErrorAction Stop
    }
    catch {
        [PSCustomObject]@{
            Target        = $Target
            Reachable     = $false
            AverageTimeMs = $null
            Status        = $_.Exception.Message
        }
        continue
    }

    # Property name differs between Windows PowerShell 5.1 and PowerShell 7+
    $Times = $Replies | ForEach-Object {
        if ($null -ne $_.ResponseTime) { $_.ResponseTime } else { $_.Latency }
    }

    $Average = ($Times | Measure-Object -Average).Average

    [PSCustomObject]@{
        Target        = $Target
        Reachable     = $true
        AverageTimeMs = if ($null -ne $Average) { [math]::Round($Average, 0) } else { $null }
        Status        = "Success"
    }
}

$Results | Format-Table -AutoSize
