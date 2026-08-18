# Active Directory PowerShell Scripts

PowerShell scripts for Active Directory administration, user reporting, computer inventory, and account monitoring.

## Requirements

- Windows PowerShell 5.1 or PowerShell 7+
- Active Directory PowerShell module
- RSAT (Remote Server Administration Tools)
- Appropriate permissions to query Active Directory

## Scripts

| Script | Description |
|---|---|
| `Export-ADUsers.ps1` | Exports Active Directory user information to CSV |
| `Find-InactiveUsers.ps1` | Identifies inactive user accounts |
| `Export-ADComputers.ps1` | Exports Active Directory computer inventory |

## Active Directory Module

The scripts use the Active Directory PowerShell module:

```powershell
Import-Module ActiveDirectory
```

If the module is not installed, install the appropriate RSAT components for your Windows environment.

## Safety

The scripts in this directory are designed for read-only reporting and inventory.

They do not modify or delete Active Directory objects.

Always test administrative scripts in a non-production environment before using them in production.

## Purpose

This collection demonstrates PowerShell automation for:

- Active Directory user reporting
- Inactive account identification
- Computer inventory
- Enterprise IT administration
- CSV-based reporting