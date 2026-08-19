# Microsoft 365 PowerShell Scripts

PowerShell automation for Microsoft 365 administration and reporting, built on the Microsoft Graph PowerShell SDK.

## Requirements

- Windows PowerShell 5.1 or PowerShell 7+
- Microsoft Graph PowerShell SDK
- Appropriate Microsoft 365 / Microsoft Entra permissions

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

## Scripts

| Script | Description | Graph permissions |
|---|---|---|
| `Connect-M365.ps1` | Connects to Microsoft Graph using delegated permissions | `User.Read.All`, `Directory.Read.All` |
| `Export-M365Users.ps1` | Exports Microsoft 365 users to CSV | `User.Read.All` |
| `Get-LicenseReport.ps1` | Tenant license inventory with assigned and available counts | `Organization.Read.All` |
| `Find-UnlicensedUsers.ps1` | Finds member accounts with no licenses assigned | `User.Read.All` |
| `Export-UserLicenseDetails.ps1` | Per-user license assignments, one row per SKU | `User.Read.All`, `Organization.Read.All` |

## Usage

```powershell
# Authenticate once for the session
.\Connect-M365.ps1

# Then run any report
.\Get-LicenseReport.ps1
.\Find-UnlicensedUsers.ps1
.\Export-UserLicenseDetails.ps1
```

Each script also connects on its own if no Graph session is active.

Full help is available for every script:

```powershell
Get-Help .\Export-UserLicenseDetails.ps1 -Full
```

## Advanced Queries

`Find-UnlicensedUsers.ps1` filters on `assignedLicenses/$count`, which is an
advanced Microsoft Graph query. These require the `ConsistencyLevel: eventual`
header, which the Graph SDK sets when `-ConsistencyLevel eventual` and
`-CountVariable` are supplied together.

Note that `$count` must be escaped in PowerShell double-quoted strings
(`` `$count ``) or the filter is sent to Graph malformed.

## Performance

`Export-UserLicenseDetails.ps1` requests `assignedLicenses` together with the
user objects and resolves SKU identifiers from a single
`Get-MgSubscribedSku` lookup.

Issuing one `Get-MgUserLicenseDetail` call per user is a common approach but
scales poorly and is likely to be throttled in larger tenants.

## Authentication and Data

Scripts authenticate through Microsoft Graph PowerShell using delegated
permissions. No passwords, client secrets, access tokens or tenant credentials
are stored in the repository.

Generated CSV reports may contain tenant user data. They are written next to
the script and excluded from Git through the repository `.gitignore`.

## Safety

All scripts in this directory are read-only. They report on the tenant and do
not create, modify or delete users, licenses or configuration.

Test in a non-production tenant before using them in production.
