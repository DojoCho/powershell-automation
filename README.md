# PowerShell Automation

[![Lint](https://github.com/DojoCho/powershell-automation/actions/workflows/lint.yml/badge.svg)](https://github.com/DojoCho/powershell-automation/actions/workflows/lint.yml)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207%2B-5391FE?logo=powershell&logoColor=white)](https://learn.microsoft.com/powershell/)
[![Platform](https://img.shields.io/badge/platform-Windows-0078D6?logo=windows&logoColor=white)](https://learn.microsoft.com/windows/)
[![License: MIT](https://img.shields.io/badge/License-MIT-success.svg)](LICENSE)

A practical collection of PowerShell scripts for Windows administration, Microsoft 365, Microsoft Intune, Active Directory and everyday IT automation.

Built around real-world endpoint management and IT support workflows, with an emphasis on repeatable administration, reporting, inventory and troubleshooting.

Every script ships with comment-based help, validated parameters, and explicit handling for the cases that actually come up in production.

---

## 🚀 Getting Started

```powershell
git clone https://github.com/DojoCho/powershell-automation.git
cd powershell-automation
```

Every script documents itself:

```powershell
Get-Help .\Windows\Get-InstalledSoftware.ps1 -Full
```

Scripts that change system state support `-WhatIf`, so you can always preview first:

```powershell
.\Utilities\Remove-OldFiles.ps1 -Path "D:\Logs" -Days 30 -WhatIf
```

---

## 📤 Example Output

Values below are illustrative, but the formatting is exactly what the scripts produce.

**`Windows/New-SystemHealthReport.ps1`**

```text
===== SYSTEM HEALTH REPORT =====
Generated: 2026-08-19 09:14:02

-- System --
Computer   : WORKSTATION-014
Model      : Dell Inc. Latitude 5540
OS         : Microsoft Windows 11 Enterprise (build 26100)
CPU        : 13th Gen Intel(R) Core(TM) i7-1365U
Uptime     : 6d 3h 22m
Last boot  : 08/13/2026 05:52:11

-- Memory --
Total : 31.72 GB
Used  : 18.44 GB (58.1%)
Free  : 13.28 GB

-- Disks --

Drive Label   TotalGB FreeGB FreePercent Status
----- -----   ------- ------ ----------- ------
C:    OS       475.35  62.18        13.1 LOW
D:    Data     931.51 402.77        43.2 OK

-- Summary --
Disks below 15% free: C:
```

**`Windows/Get-InstalledSoftware.ps1`**

Reads all three uninstall registry locations, so 32-bit and per-user installations
are included rather than silently dropped.

```text
DisplayName                     DisplayVersion Publisher              Scope
-----------                     -------------- ---------              -----
7-Zip 23.01                     23.01          Igor Pavlov            Machine (32-bit)
Google Chrome                   127.0.6533.100 Google LLC             Machine (64-bit)
Microsoft 365 Apps for business 16.0.17830     Microsoft Corporation  Machine (64-bit)
Microsoft Teams                 24165.1414     Microsoft Corporation  User
Notepad++ (64-bit x64)          8.6.9          Notepad++ Team         Machine (64-bit)
```

**`Utilities/New-RandomPassword.ps1`**

```text
PS> .\New-RandomPassword.ps1 -Length 20 -Count 3

f_acFT=su(B+Sk3cD#Ex
WCS^co7$RXeGL4wq9{tm
j9Rwmpqp&Zn#s5vTX2gd
```

**`Utilities/Test-NetworkConnection.ps1`**

```text
Target        Reachable AverageTimeMs Status
------        --------- ------------- ------
dc01          True                  2 Success
google.com    True                 11 Success
fileserver01  False                   Testing connection to computer 'fileserver01' failed
```

**`Utilities/Remove-OldFiles.ps1`** — destructive scripts preview with `-WhatIf`

```text
PS> .\Remove-OldFiles.ps1 -Path "D:\Logs" -Days 30 -WhatIf

Scanning for files older than 30 days...
Path   : D:\Logs
Cutoff : 2026-07-20 09:14

Files matched : 148
Space to free : 512.4 MB

What if: Performing the operation "Remove file" on target "D:\Logs\app-2026-06-02.log".
What if: Performing the operation "Remove file" on target "D:\Logs\app-2026-06-03.log".
...

Cleanup finished.
Files removed : 0
Failed        : 0
```

---

## 📂 Repository Structure

```text
powershell-automation/
│
├── .github/
│   └── workflows/
│       └── lint.yml
│
├── ActiveDirectory/
│   ├── Export-ADComputers.ps1
│   ├── Export-ADUsers.ps1
│   ├── Find-InactiveUsers.ps1
│   └── README.md
│
├── Intune/
│   ├── Find-NonCompliantDevices.ps1
│   ├── Get-AutopilotDevices.ps1
│   ├── Get-ManagedDevices.ps1
│   └── README.md
│
├── Microsoft365/
│   ├── Connect-M365.ps1
│   ├── Export-M365Users.ps1
│   ├── Export-UserLicenseDetails.ps1
│   ├── Find-UnlicensedUsers.ps1
│   ├── Get-LicenseReport.ps1
│   └── README.md
│
├── Utilities/
│   ├── Backup-Folder.ps1
│   ├── Find-LargeFiles.ps1
│   ├── Get-DiskUsage.ps1
│   ├── New-RandomPassword.ps1
│   ├── Remove-OldFiles.ps1
│   ├── Test-NetworkConnection.ps1
│   └── README.md
│
├── Windows/
│   ├── Clear-TempFiles.ps1
│   ├── Export-EventLogs.ps1
│   ├── Export-InstalledDrivers.ps1
│   ├── Get-BitLockerStatus.ps1
│   ├── Get-InstalledSoftware.ps1
│   ├── Get-SystemInfo.ps1
│   ├── New-SystemHealthReport.ps1
│   ├── Restart-StoppedServices.ps1
│   └── README.md
│
├── .gitignore
├── LICENSE
├── PSScriptAnalyzerSettings.psd1
└── README.md
```

Each directory has its own README with the script list, required permissions and usage examples.

---

## 🖥️ Windows Administration

Windows endpoint administration, diagnostics, maintenance and reporting.

- Hardware and operating system inventory
- Installed software reporting across 64-bit, 32-bit and per-user registry keys
- Device driver reporting
- BitLocker status reporting
- Event log exports
- System health reporting with uptime, memory and disk thresholds
- Temporary file cleanup
- Stopped service management

📁 [Windows/](Windows/)

---

## ☁️ Microsoft 365

Microsoft 365 administration and reporting through Microsoft Graph.

- Microsoft Graph authentication
- User reporting
- Tenant license inventory with assigned and available counts
- Unlicensed account identification
- Per-user license assignment reporting

📁 [Microsoft365/](Microsoft365/)

---

## 📱 Microsoft Intune

Endpoint inventory, compliance reporting and Windows Autopilot administration.

- Managed device inventory
- Compliance state reporting
- Windows Autopilot device identities

📁 [Intune/](Intune/)

---

## 🏢 Active Directory

Active Directory reporting, account monitoring and computer inventory.

- User reporting
- Inactive account identification
- Computer inventory

📁 [ActiveDirectory/](ActiveDirectory/)

---

## 🛠️ Utilities

General-purpose utilities for IT support and automation.

- Timestamped folder backup
- Large file discovery
- Age-based file cleanup
- Cryptographically secure password generation
- Disk usage reporting
- Network connectivity testing

📁 [Utilities/](Utilities/)

---

## 📐 Conventions

Scripts across this repository follow a consistent set of rules:

- **Approved verbs.** Every script name uses an approved PowerShell verb (`Get-`, `New-`, `Export-`, `Find-`, `Remove-`, `Test-`, `Backup-`, `Clear-`, `Restart-`).
- **Comment-based help.** `Get-Help` works on every script, including `.EXAMPLE` blocks.
- **Validated parameters.** Ranges, sets and path checks are enforced by the parameter block rather than by ad-hoc checks.
- **`-WhatIf` on anything destructive.** Scripts that delete files or change services implement `SupportsShouldProcess`.
- **Honest output.** Summaries report what actually happened, including items that were skipped or failed.
- **Reports next to the script.** CSV output is written to `$PSScriptRoot` and excluded from Git.
- **5.1 and 7+.** Scripts avoid cmdlets and .NET APIs that exist in only one of the two.

These are enforced in CI, not just documented. Every push runs
[the Lint workflow](.github/workflows/lint.yml), which fails the build if any script
does not parse, is missing comment-based help, uses an unapproved verb, or trips
PSScriptAnalyzer.

`PSAvoidUsingWriteHost` is the one rule excluded, with the reasoning recorded in
[`PSScriptAnalyzerSettings.psd1`](PSScriptAnalyzerSettings.psd1): these are interactive
administration scripts whose status output is meant for an operator at a console, while
data intended for callers is returned as objects or written to CSV.

---

## ⚠️ Read-Only vs. State-Changing

Most of this repository is read-only reporting. Three scripts change system state and are clearly marked in their directory README:

| Script | Effect |
|---|---|
| `Utilities/Remove-OldFiles.ps1` | Deletes files older than a threshold |
| `Windows/Clear-TempFiles.ps1` | Deletes temporary files |
| `Windows/Restart-StoppedServices.ps1` | Starts stopped automatic services |

All three support `-WhatIf` and `-Confirm`. Run them with `-WhatIf` first.

Everything in `ActiveDirectory/`, `Intune/` and `Microsoft365/` is read-only and does not create, modify or delete directory objects, devices, licenses or policy.

---

## 🔐 Security & Data Protection

This repository is designed to avoid storing sensitive enterprise information.

Scripts do not contain passwords, API keys, access tokens, client secrets, tenant credentials or production user data.

Microsoft 365 and Intune scripts authenticate through Microsoft Graph using delegated permissions, so nothing is persisted to disk.

Generated reports such as CSV files, logs and temporary files are excluded through `.gitignore`.

Generated reports **can** contain tenant and user data. Always review output before sharing or publishing it.

---

## ⚙️ Requirements

Depending on the script:

- Windows PowerShell 5.1 or PowerShell 7+
- Microsoft Graph PowerShell SDK — `Install-Module Microsoft.Graph -Scope CurrentUser`
- Active Directory PowerShell module (RSAT)
- Appropriate Microsoft 365 / Microsoft Entra permissions
- Appropriate Microsoft Intune permissions
- An elevated session for a small number of Windows scripts

Each directory README lists the specific requirements and Graph permissions for its scripts.

---

## 🎯 Purpose

This repository demonstrates practical PowerShell automation across common IT administration workflows: endpoint management, identity and access administration, Microsoft 365, Intune, Active Directory, reporting, inventory, troubleshooting and repetitive task automation.

Scripts are organized by administrative domain so individual tools can be reused independently.

---

## ⚠️ Disclaimer

These scripts are provided for educational, administrative and automation purposes.

Always review and test scripts in a controlled, non-production environment before using them in production.

Scripts that interact with Microsoft 365, Intune or Active Directory may require additional permissions and configuration depending on the environment.

---

## 📄 License

Released under the [MIT License](LICENSE).

---

## 👤 Author

**Ali Ekrem San** — IT Support Engineer

Endpoint management, Microsoft 365, Intune, Active Directory and PowerShell automation.

[alitechit.com](https://alitechit.com) · [LinkedIn](https://www.linkedin.com/in/aliekremsan) · [GitHub](https://github.com/DojoCho)
