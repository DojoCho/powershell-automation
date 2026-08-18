<#
.SYNOPSIS
Connects to Microsoft Graph using delegated permissions.

.DESCRIPTION
Authenticates the current administrator to Microsoft Graph
for Microsoft 365 administration and reporting tasks.

.NOTES
Requires the Microsoft.Graph PowerShell SDK.

The script does not store credentials, passwords, or secrets.
#>

# Required Microsoft Graph scopes
$Scopes = @(
    "User.Read.All",
    "Directory.Read.All"
)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Microsoft 365 / Graph Authentication" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check whether Microsoft Graph PowerShell SDK is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {

    Write-Host "Microsoft Graph PowerShell SDK is not installed." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Install it with:" -ForegroundColor Yellow
    Write-Host "Install-Module Microsoft.Graph -Scope CurrentUser"
    Write-Host ""

    exit 1
}

# Connect to Microsoft Graph
Connect-MgGraph -Scopes $Scopes

# Display current authentication context
$Context = Get-MgContext

Write-Host ""
Write-Host "Connected successfully." -ForegroundColor Green
Write-Host "Account : $($Context.Account)"
Write-Host "Tenant  : $($Context.TenantId)"
Write-Host ""