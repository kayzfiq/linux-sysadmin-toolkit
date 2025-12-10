# Automated System Updates

Automated system update script with systemd service and timer for Debian-based systems.

## 📋 Overview

This solution provides automated package updates with comprehensive logging and systemd integration.

## 🎯 Features

- ✅ Automated updates on schedule
- ✅ Detailed logging to `/var/log/system-updates/`
- ✅ Automatic log cleanup (30-day retention)
- ✅ Reboot detection and notification
- ✅ Non-interactive execution
- ✅ Security-hardened systemd service

## 📦 Files
```
system-updates/
├── system-update.sh          # Main update script
├── system-update.service     # Systemd service file
├── system-update.timer       # Systemd timer file
└── README.md                 # This file
```


## 🚀 Quick Start

### Installation

# Copy files to system locations
`sudo cp system-update.sh /usr/local/bin/`
`sudo chmod +x /usr/local/bin/system-update.sh`

`sudo cp system-update.service /etc/systemd/system/`
`sudo cp system-update.timer /etc/systemd/system/`

# Enable and start the timer
`sudo systemctl daemon-reload`

`sudo systemctl enable system-update.timer`

`sudo systemctl start system-update.timer`


### Verification

# Check timer status
`systemctl status system-update.timer`

# View next scheduled run
`systemctl list-timers system-update.timer`


## 📊 Usage

### Manual Execution

`sudo systemctl start system-update.service`


### View Logs

# Latest log
`sudo cat /var/log/system-updates/latest.log`

# All logs
`ls -lh /var/log/system-updates/`

# Systemd journal
`sudo journalctl -u system-update.service -n 50`


## ⚙️ Configuration

### Change Schedule

Edit the timer file:

sudo nano /etc/systemd/system/system-update.timer


Common schedules:

# Daily at 3 AM
OnCalendar=*-*-* 03:00:00

# Weekly on Sunday at 2 AM
OnCalendar=Sun *-*-* 02:00:00

# Every 6 hours
OnCalendar=*-*-* 00,06,12,18:00:00


Apply changes:

sudo systemctl daemon-reload
sudo systemctl restart system-update.timer


### Adjust Log Retention

Edit script and modify:

RETENTION_DAYS=30  # Change this value


## 🔍 Troubleshooting

### Timer Not Running

# Check if enabled
systemctl is-enabled system-update.timer

# View errors
systemctl status system-update.timer


### Service Failures

# View detailed errors
sudo journalctl -xe -u system-update.service

# Test manually
sudo /usr/local/bin/system-update.sh


## 📝 Log Format

Logs include:
- Timestamps for each action
- Success/failure indicators
- Command outputs
- Reboot requirements
- Disk space information

## 🔒 Security

Service includes security hardening:
- Private temporary directories
- Protected system files
- No privilege escalation
- Minimal write permissions

## 📚 Resources

- [Systemd Timer Documentation](https://www.freedesktop.org/software/systemd/man/systemd.timer.html)
- [APT Command Reference](https://manpages.debian.org/apt-get)

## 💡 What I Learned

Creating this automation taught me:
- Systemd service and timer creation
- Bash scripting with error handling
- Log management and rotation
- Security hardening for services
- Non-interactive package management

## 🤝 Contributing

Found an issue? Have an improvement? Open an issue or PR!

---

**Part of:** [Linux SysAdmin Toolkit](../../README.md)
