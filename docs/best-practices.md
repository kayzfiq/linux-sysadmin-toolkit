# Best Practices for Linux System Administration

Lessons learned while building this repository and working with production systems.

## General Principles

### 1. Always Have Backups

# Before making changes
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup.$(date +%Y%m%d)


### 2. Test Before Production
- Use VMs for testing
- Create staging environments
- Never test directly on production

### 3. Document Everything
- Why you made changes
- What you changed
- How to revert
- Date and time of changes

### 4. Use Version Control
- Track configuration changes
- Keep scripts in git
- Write meaningful commit messages

### 5. Follow Principle of Least Privilege
- Don't run as root unless necessary
- Use sudo for specific commands
- Create service accounts for applications

## Security Best Practices

### SSH Configuration

# Essential settings
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
Port 2222  # Change default port


### File Permissions

# Configuration files
chmod 644 /etc/config-file.conf
chown root:root /etc/config-file.conf

# Scripts
chmod 750 /usr/local/bin/script.sh
chown root:root /usr/local/bin/script.sh

# Sensitive files
chmod 600 /etc/sensitive/credentials


### Regular Updates

# Keep system updated
sudo apt update && sudo apt upgrade -y

# Enable automatic security updates
sudo apt install unattended-upgrades


### Firewall Rules

# Default deny, explicit allow
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw enable


## Scripting Best Practices

### 1. Always Include Shebang

#!/bin/bash


### 2. Use Error Handling

set -euo pipefail  # Exit on error, undefined variables, pipe failures

# Or manual checking
if ! command; then
    echo "Error: Command failed" >&2
    exit 1
fi


### 3. Validate Input

if [ -z "$1" ]; then
    echo "Error: Missing required argument"
    exit 1
fi


### 4. Log Everything Important

LOG_FILE="/var/log/script.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Script started"


### 5. Make Scripts Idempotent
Scripts should be safe to run multiple times:

# Check before creating
if [ ! -d "/var/log/myapp" ]; then
    mkdir -p /var/log/myapp
fi


### 6. Use Functions

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Error: Must run as root"
        exit 1
    fi
}

check_root


## Service Management

### Systemd Best Practices

1. **Always use systemctl**

# Not: service nginx restart
sudo systemctl restart nginx


2. **Check status after changes**

sudo systemctl restart service
sudo systemctl status service


3. **Enable services to start on boot**

sudo systemctl enable service


4. **Use timers instead of cron**
- Better logging
- Easier debugging
- More features

## Monitoring & Logging

### What to Monitor
- CPU, Memory, Disk usage
- Network traffic
- Service availability
- Failed login attempts
- Disk I/O
- System load

### Log Management

# Use logrotate for log rotation
# Configure in /etc/logrotate.d/

/var/log/myapp/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
}


### Centralized Logging
- Send logs to central location
- Use rsyslog or syslog-ng
- Consider ELK stack for analysis

## Backup Strategies

### 3-2-1 Rule
- **3** copies of data
- **2** different media types
- **1** off-site copy

### What to Backup
- Configuration files (/etc)
- User data
- Databases
- Application data
- System state

### Backup Script Example

#!/bin/bash
BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d)

tar -czf "$BACKUP_DIR/etc-$DATE.tar.gz" /etc
tar -czf "$BACKUP_DIR/home-$DATE.tar.gz" /home

# Keep only last 7 days
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete


## Performance Optimization

### Check Before Optimizing

# CPU usage
top
htop

# Memory usage
free -h
vmstat

# Disk I/O
iostat
iotop

# Network
iftop
nethogs


### Don't Premature Optimize
- Measure first
- Identify bottleneck
- Optimize specific issue
- Measure again

## Documentation

### What to Document
- System architecture
- Network topology
- Service dependencies
- Recovery procedures
- Contact information
- Change history

### How to Document
- Keep it in version control
- Use markdown for readability
- Include diagrams
- Update regularly
- Make it searchable

## Automation Philosophy

### When to Automate
- ✅ Repetitive tasks
- ✅ Error-prone manual processes
- ✅ Time-consuming operations
- ✅ Tasks run frequently

### When NOT to Automate
- ❌ One-time tasks
- ❌ When you don't understand the process
- ❌ Critical operations without testing
- ❌ When manual review is important

## Disaster Recovery

### Be Prepared
- Document recovery procedures
- Test backups regularly
- Have recovery plan
- Know your RTO/RPO
- Keep recovery tools accessible

### Recovery Plan Should Include
1. Contact information
2. System inventory
3. Backup locations
4. Recovery steps
5. Verification procedures

## Common Mistakes to Avoid

### ❌ Running commands without understanding

# Don't blindly copy-paste from internet
curl http://random-site.com/script.sh | sudo bash


### ❌ No testing before production
- Always test in safe environment

### ❌ Ignoring logs
- Logs tell you what's happening
- Check them regularly

### ❌ Not having rollback plan
- Know how to revert changes
- Test rollback procedure

### ❌ Hardcoding credentials

# Don't do this
PASSWORD="mysecretpass"

# Do this instead
PASSWORD=$(cat /etc/secrets/password)


### ❌ Not documenting changes
- Future you will thank present you

## Resources for Continuous Learning

### Follow
- /r/sysadmin (Reddit)
- /r/linuxadmin (Reddit)
- Hacker News
- Linux Weekly News
- x communities

### Practice
- Build homelab
- Break things and fix them
- Contribute to open source
- Write about what you learn

### Certifications
- LPIC-1/2
- RHCSA/RHCE
- Linux Foundation certifications

## My Learning Process

1. **Learn concept** - Read documentation
2. **Implement** - Try in lab
3. **Break it** - Understand failure modes
4. **Fix it** - Learn troubleshooting
5. **Document** - Write it down
6. **Teach** - Share with others

---

These practices have saved me countless hours and prevented many mistakes. Learn from my experience! 🎓
