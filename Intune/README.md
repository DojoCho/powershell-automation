# Microsoft Intune PowerShell Scripts

PowerShell automation scripts for Microsoft Intune device management, reporting, compliance monitoring, and Windows Autopilot administration.

## Requirements

- PowerShell 7+
- Microsoft Graph PowerShell SDK
- Appropriate Microsoft Intune / Microsoft Entra permissions
- Microsoft Graph permissions required by each script

## Scripts

| Script | Description |
|---|---|
| `Get-ManagedDevices.ps1` | Exports managed Intune devices and device details to CSV |
| `Find-NonCompliantDevices.ps1` | Identifies Intune devices that are not compliant |
| `Get-AutopilotDevices.ps1` | Exports Windows Autopilot device identities and deployment information |

## Microsoft Graph Permissions

The scripts use read-only Microsoft Graph permissions where possible:

- `DeviceManagementManagedDevices.Read.All`
- `DeviceManagementServiceConfig.Read.All`

These permissions may require administrator consent depending on the tenant configuration.

## Authentication

Scripts authenticate through Microsoft Graph PowerShell using delegated permissions.

No passwords, client secrets, access tokens, or tenant credentials are stored in the repository.

## Generated Reports

Scripts may generate CSV reports containing tenant/device information.

Generated CSV files are excluded from Git through the repository `.gitignore` file.

## Safety

The scripts in this directory are designed primarily for read-only reporting and inventory operations.

Test scripts in a non-production environment before using them in an enterprise environment.

## Purpose

This collection demonstrates practical PowerShell automation for:

- Intune device inventory
- Device compliance reporting
- Windows Autopilot administration
- Microsoft Graph automation
- Enterprise endpoint management