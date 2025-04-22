# Dev Drive Support Scripts

This repository contains scripts to assist in configuring and managing Windows Dev Drives. Dev Drive is a new storage volume type introduced in Windows 11, designed to improve performance for developer workloads. It leverages the Resilient File System (ReFS) to provide optimizations tailored for development scenarios.

## About Windows Dev Drive

Windows Dev Drive offers:
- **Enhanced Performance**: Optimized for source code, build outputs, and package caches.
- **Flexibility**: Supports both disk partitions and virtual hard disks (VHDs).
- **Security**: Allows configuration of trust designations and antivirus settings.

### Key Features
- Built on ReFS for improved data integrity and performance.
- Customizable storage settings for development workloads.
- Integration with tools like Visual Studio for faster build times.

For more details, visit the [official documentation](https://learn.microsoft.com/en-us/windows/dev-drive/).

## Repository Contents

- **scripts/**: Contains PowerShell and other scripts to simplify the setup and management of Dev Drives.
- **LICENSE**: Licensing information for this repository.
- **README.md**: Overview and documentation for this repository.

## Getting Started

1. Ensure your system meets the prerequisites for Dev Drive:
   - Windows 11, Build #10.0.22621.2338 or later.
   - Minimum 50GB free disk space.
   - Local administrator permissions.
2. Use the scripts in this repository to configure your Dev Drive.

## Contributing

Contributions are welcome! Please submit issues or pull requests to help improve this repository.