## Linux User Management Script

A comprehensive Bash script for managing user accounts on Linux systems with advanced features including bulk user creation, security auditing, and password policy enforcement.

## Features

* 🔐 Single & Bulk User Creation - Create individual users or import multiple users from CSV
* 🔒 Account Locking/Unlocking - Quickly disable or re-enable user accounts
* 🔑 Password Management - Reset passwords with random generation option
* 📊 Security Auditing - Comprehensive system-wide user audit reports
* 🗑️ Safe User Deletion - Automatic home directory backup before deletion
* ⚡ Password Policy Enforcement - System-wide strong password requirements
* 📝 Full Activity Logging - All operations logged to `/var/log/user_management.log`
* 🎨 Interactive Menu - User-friendly colored interface

## Prerequisites

* Linux OS (Ubuntu, Debian, CentOS, RHEL, Fedora)
* Root or sudo privileges
* Bash 4.0 or higher

## Required Packages
Most are pre-installed, but the script will attempt to install missing dependencies:

* openssl - For random password generation
* libpam-pwquality (Debian/Ubuntu) or pam_pwquality (RHEL/CentOS) - For password policy enforcement

## Installation

**Quick Install**
```
# Download the script
wget https://raw.githubusercontent.com/kayzfiq/linux-sysadmin-toolkit/tree/main/automation/user-management/user_management.sh

# Make it executable
chmod +x user_management.sh

# Run with sudo
sudo ./user_management.sh
```

**System-wide Installation**

```
# Copy to system bin
sudo cp user_management.sh /usr/local/bin/user_management

# Make executable
sudo chmod +x /usr/local/bin/user_management

# Run from anywhere
sudo user_management
```

**Usage**

**Interactive Menu**
Simply run the script and follow the interactive menu:

```
sudo ./user_management.sh
```

**Menu options**

1. **Create Single User**  -  Interactive user creation with optional custom password

2. **Bulk Create Users** - Import users from CSV file

3. **Lock User Account** - Disable user login without deletion

4. **Unlock User Account** - Re-enable locked accounts

5. **Reset Password** - Change user password

6. **Audit Users** - Generate comprehensive security report

7. **List Active Users** - Show recently logged-in users (last 30 days)

8. **List Regular Users** - Display all non-system users (UID ≥ 1000)

9. **Delete User** - Remove user with automatic home directory backup

10. **Enforce Password Policy** - Apply strong password requirements system-wide

11. **View Log** - Display recent script activity

0. **Exit** - Close the script

**Bulk User Creation**

**CSV Format**

Create a CSV file at `/tmp/bulk_users.csv` with the following format:

```
username,password,fullname,groups
john,SecurePass123!,John Doe,developers,sudo
jane,AnotherPass456!,Jane Smith,developers
bob,BobPass789!,Bob Johnson,
```

**Fields:**

`username` - Required, alphanumeric

`password` - Required, will be validated against policy if enforced

`fullname` - Optional, user's full name

`groups` - Optional, comma-separated additional groups

**Example**

```
# Create sample CSV
cat > /tmp/bulk_users.csv << EOF
alice,AlicePass1!,Alice Williams,developers
charlie,CharliePass2!,Charlie Brown,sudo
EOF

# Run script and select option 2
sudo ./user_management.sh
```

**Password Policy**

When you enable Enforce Strong Password Policy (option 10), the following rules apply system-wide:

* Minimum 12 characters

* At least 1 uppercase letter

* At least 1 lowercase letter

* At least 1 digit

* At least 1 special character

* Maximum 2 repeating characters

* Must differ from previous passwords by at least 7 characters

* Enforced for root account as well

**Security Features**

**Automatic Backups**

Before deleting any user, the script automatically:

* Creates a tarball of the user's home directory
* Stores backup in `/var/backups/user_homes/`
* Names backup with timestamp: `username_home_YYYYMMDD_HHMMSS.tar.gz`

**Activity Logging**

All operations are logged with timestamps to `/var/log/user_management.log`:

```
2024-12-10 14:30:45 | root | CREATED user john
2024-12-10 14:31:12 | root | LOCKED user john
2024-12-10 14:32:01 | root | DELETED user john (home backed up)
```


**Audit Reports**

The audit feature provides:

* Last login information
* Users with login shells
* Users with root privileges (UID 0)
* Password expiration status for all accounts

**Troubleshooting**

**"This script must be run as root"**

Run with sudo:
```
sudo ./user_management.sh
```

**"File /tmp/bulk_users.csv not found"**

Ensure your CSV file exists:
```
ls -l /tmp/bulk_users.csv
```

**Password policy not working**

Install required package:
```
# Ubuntu/Debian
sudo apt-get install libpam-pwquality

# RHEL/CentOS/Fedora
sudo yum install pam_pwquality
```

**Contributing**

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (git checkout -b feature/AmazingFeature)
3. Commit your changes (git commit -m 'Add some AmazingFeature')
4. Push to the branch (git push origin feature/AmazingFeature)
5. Open a Pull Request

**License**

This project is licensed under the MIT License - see the LICENSE file for details.