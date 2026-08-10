<#
.SYNOPSIS
Tests connectivity to common services.
#>

$hosts = @(
    "google.com",
    "github.com",
    "microsoft.com"
)

foreach($host in $hosts){

    Test-Connection $host -Count 2

}