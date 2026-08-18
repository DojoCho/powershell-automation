# PowerShell Automation

A practical collection of PowerShell scripts for Windows administration, Microsoft 365, Microsoft Intune, Active Directory, and everyday IT automation.

Built around real-world endpoint management and IT support workflows, with an emphasis on repeatable administration, reporting, inventory, and troubleshooting.

---

## 📂 Repository Structure

```text
powershell-automation/
│
├── ActiveDirectory/
│   ├── Export-ADUsers.ps1
│   ├── Find-InactiveUsers.ps1
│   ├── Export-ADComputers.ps1
│   └── README.md
│
├── Intune/
│   ├── Get-ManagedDevices.ps1
│   ├── Find-NonCompliantDevices.ps1
│   ├── Get-AutopilotDevices.ps1
│   └── README.md
│
├── Microsoft365/
│   ├── Connect-M365.ps1
│   ├── Export-M365Users.ps1
│   ├── Get-LicenseReport.ps1
│   ├── Find-UnlicensedUsers.ps1
│   ├── Export-UserLicenseDetails.ps1
│   └── README.md
│
├── Utilities/
│   ├── Backup-Folder.ps1
│   ├── Find-LargeFiles.ps1
│   ├── FolderCleanup.ps1
│   ├── Generate-RandomPassword.ps1
│   ├── Get-DiskUsage.ps1
│   ├── Get-FileHash.ps1
│   ├── Test-NetworkConnection.ps1
│   └── README.md
│
├── Windows/
│   ├── Check-BitLockerStatus.ps1
│   ├── Clear-TempFiles.ps1
│   ├── Export-EventLogs.ps1
│   ├── Export-InstalledDrivers.ps1
│   ├── Generate-SystemHealthReport.ps1
│   ├── Get-InstalledSoftware.ps1
│   ├── Get-SystemInfo.ps1
│   ├── Restart-StoppedServices.ps1
│   └── README.md
│
├── .gitignore
└── README.md
```

---

## 🖥️ Windows Administration

Scripts for common Windows endpoint administration, diagnostics, maintenance, and system reporting.

### Includes

- System information and hardware inventory
- Installed software reporting
- Installed driver reporting
- BitLocker status checks
- Windows event log exports
- System health reporting
- Temporary file cleanup
- Stopped service management

---

## ☁️ Microsoft 365

PowerShell automation using Microsoft Graph for Microsoft 365 administration and reporting.

### Includes

- Microsoft 365 user reporting
- License inventory and reporting
- Unlicensed user identification
- Per-user license details
- Microsoft Graph authentication

The Microsoft 365 scripts are designed around Microsoft Graph PowerShell and use delegated permissions rather than storing credentials or secrets in the repository.

---

## 📱 Microsoft Intune

PowerShell automation for endpoint inventory, compliance reporting, and Windows Autopilot administration.

### Includes

- Managed device inventory
- Non-compliant device reporting
- Windows Autopilot device reporting
- Microsoft Graph-based Intune administration

The Intune scripts are primarily read-only reporting and inventory tools.

---

## 🏢 Active Directory

PowerShell scripts for Active Directory reporting, account monitoring, and computer inventory.

### Includes

- Active Directory user reporting
- Inactive account identification
- Computer inventory
- Account and device reporting

The Active Directory scripts are designed for read-only administration and reporting.

---

## 🛠️ Utilities

General-purpose PowerShell utilities for IT support, file management, troubleshooting, and automation.

### Includes

- Folder backup
- Large file discovery
- Folder cleanup
- Random password generation
- Disk usage reporting
- File hashing
- Network connectivity testing

---

## 🔐 Security & Data Protection

This repository is designed to avoid storing sensitive enterprise information.

Generated reports such as CSV files, logs, and temporary files are excluded through `.gitignore`.

Scripts do not contain:

- Passwords
- API keys
- Access tokens
- Client secrets
- Tenant credentials
- Production user data

Always review generated output before sharing or publishing it.

---

## ⚙️ Requirements

Depending on the script, requirements may include:

- Windows PowerShell 5.1 or PowerShell 7+
- Microsoft Graph PowerShell SDK
- Active Directory PowerShell module
- RSAT (Remote Server Administration Tools)
- Appropriate Microsoft 365 / Microsoft Entra permissions
- Appropriate Microsoft Intune permissions

Each directory contains its own README with script-specific requirements and usage information.

---

## 🎯 Purpose

This repository demonstrates practical PowerShell automation used across common IT administration workflows.

The focus is on:

- Endpoint management
- System administration
- Identity and access administration
- Microsoft 365 administration
- Microsoft Intune
- Active Directory
- Reporting and inventory
- Troubleshooting
- Repetitive task automation

The scripts are intentionally organized by administrative domain so individual tools can be reused independently.

---

## ⚠️ Disclaimer

These scripts are provided for educational, administrative, and automation purposes.

Always review and test scripts in a controlled, non-production environment before using them in a production environment.

Scripts that interact with Microsoft 365, Intune, or Active Directory may require additional permissions and configuration depending on the environment.

---

## 👤 Author

**Ali Ekrem San**

IT Support Engineer focused on endpoint management, Microsoft 365, Intune, Active Directory, PowerShell automation, and practical IT solutions.

**AliTech IT**

---