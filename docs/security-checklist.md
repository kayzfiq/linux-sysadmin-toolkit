# Linux Security Hardening Checklist

Essential security measures for Linux servers. Use this checklist when setting up new systems.

## Initial Setup

### ☐ System Updates
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

### ☐ Create Non-Root User
```bash
adduser adminuser
usermod -aG sudo adminuser
```

### ☐ Configure Hostname
```bash
hostnamectl set-hostname your-hostname
```

## SSH Hardening

### ☐ Disable Root Login
```bash
# /etc/ssh/sshd_config
PermitRootLogin no
```

### ☐ Disable Password Authentication
```bash
# /etc/ssh/sshd_config
PasswordAuthentication no
PubkeyAuthentication yes
```

### ☐ Change Default Port
```bash
# /etc/ssh/sshd_config
Port 2222  # Choose your port
```

### ☐ Limit User Access
```bash
# /etc/ssh/sshd_config
AllowUsers adminuser
```

### ☐ Set SSH Timeout
```bash
# /etc/ssh/sshd_config
ClientAliveInterval 300
ClientAliveCountMax 2
```

### ☐ Restart SSH Service
```bash
sudo systemctl restart sshd
```

## Firewall Configuration

### ☐ Install UFW
```bash
sudo apt install ufw
```

### ☐ Set Default Policies
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

### ☐ Allow Essential Services
```bash
sudo ufw allow 2222/tcp  # SSH (your custom port)
sudo ufw allow 80/tcp    # HTTP (if needed)
sudo ufw allow 443/tcp   # HTTPS (if needed)
```

### ☐ Enable Firewall
```bash
sudo ufw enable
sudo ufw status verbose
```

## Fail2Ban Setup

### ☐ Install Fail2Ban
```bash
sudo apt install fail2ban
```

### ☐ Configure SSH Jail
```bash
# /etc/fail2ban/jail.local
[sshd]
enabled = true
port = 2222
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
```

### ☐ Start Fail2Ban
```bash
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

## User & Permission Management

### ☐ Review Sudo Access
```bash
sudo visudo
```

### ☐ Set Password Policies
```bash
# /etc/login.defs
PASS_MAX_DAYS 90
PASS_MIN_DAYS 1
PASS_WARN_AGE 7
```

### ☐ Lock Unused Accounts
```bash
sudo usermod -L username
```

### ☐ Remove Unnecessary Users
```bash
sudo userdel -r username
```

## File System Security

### ☐ Set Proper Permissions
```bash
# Secure /etc directory
sudo chmod 755 /etc
sudo chown root:root /etc

# Secure important files
sudo chmod 644 /etc/passwd
sudo chmod 600 /etc/shadow
sudo chmod 644 /etc/group
```

### ☐ Find World-Writable Files
```bash
sudo find / -xdev -type f -perm -0002 -ls
```

### ☐ Find Files with No Owner
```bash
sudo find / -xdev -nouser -ls
```

## Service Hardening

### ☐ Disable Unnecessary Services
```bash
# List all services
systemctl list-unit-files --type=service

# Disable unwanted services
sudo systemctl disable service-name
sudo systemctl stop service-name
```

### ☐ Review Running Services
```bash
sudo ss -tulpn
```

## Network Security

### ☐ Disable IPv6 (if not used)
```bash
# /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1

sudo sysctl -p
```

### ☐ Enable SYN Cookie Protection
```bash
# /etc/sysctl.conf
net.ipv4.tcp_syncookies = 1

sudo sysctl -p
```

### ☐ Disable IP Forwarding
```bash
# /etc/sysctl.conf
net.ipv4.ip_forward = 0

sudo sysctl -p
```

## Logging & Monitoring

### ☐ Configure Rsyslog
```bash
# Ensure rsyslog is running
sudo systemctl status rsyslog
```

### ☐ Set Up Log Rotation
```bash
# Check /etc/logrotate.d/ configurations
ls -la /etc/logrotate.d/
```

### ☐ Monitor Auth Logs
```bash
sudo tail -f /var/log/auth.log
```

### ☐ Install Monitoring Tools
```bash
sudo apt install htop iotop nethogs
```

## Automatic Updates

### ☐ Enable Security Updates
```bash
# /etc/apt/apt.conf.d/50unattended-upgrades
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
};
```

### ☐ Configure Update Schedule
```bash
# /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
```

## Additional Security Measures

### ☐ Install and Configure AppArmor
```bash
sudo apt install apparmor apparmor-utils
sudo systemctl status apparmor
```

### ☐ Set Up Audit Daemon
```bash
sudo apt install auditd
sudo systemctl enable auditd
sudo systemctl start auditd
```

### ☐ Install AIDE (File Integrity)
```bash
sudo apt install aide
sudo aideinit
```

### ☐ Configure Time Synchronization
```bash
sudo apt install systemd-timesyncd
sudo timedatectl set-ntp true
```

## Backup & Recovery

### ☐ Set Up Automated Backups
- Configuration files (/etc)
- User data (/home)
- Application data
- Database backups

### ☐ Test Backup Restoration
- Verify backups work
- Document restoration process

### ☐ Off-site Backup Copy
- Keep copy in different location
- Use encryption for sensitive data

## Regular Maintenance Tasks

### ☐ Weekly Tasks
- Review logs for anomalies
- Check disk space usage
- Review active users and sessions
- Check failed login attempts

### ☐ Monthly Tasks
- Review and update firewall rules
- Audit user accounts and permissions
- Review installed packages
- Test backup restoration
- Check for security updates

### ☐ Quarterly Tasks
- Full security audit
- Review and update documentation
- Test disaster recovery plan
- Review and update security policies

## Security Scanning

### ☐ Run Lynis Security Audit
```bash
sudo apt install lynis
sudo lynis audit system
```

### ☐ Scan for Rootkits
```bash
sudo apt install rkhunter chkrootkit
sudo rkhunter --check
sudo chkrootkit
```

### ☐ Check Open Ports
```bash
sudo nmap -sT -O localhost
sudo ss -tulpn
```

## Compliance & Standards

### ☐ CIS Benchmark Compliance
- Download CIS Benchmark for your distribution
- Implement recommended settings
- Document deviations

### ☐ Document Security Measures
- Keep security documentation updated
- Record all changes
- Maintain change log

## Emergency Contacts

### ☐ Document Contact Information
- System administrator
- Security team
- Management
- Service providers
- Emergency response team

## Post-Compromise Checklist

If system is compromised:

1. ☐ Isolate the system
2. ☐ Preserve evidence
3. ☐ Document everything
4. ☐ Notify appropriate parties
5. ☐ Analyze logs
6. ☐ Identify attack vector
7. ☐ Remove malicious content
8. ☐ Patch vulnerabilities
9. ☐ Restore from clean backup
10. ☐ Monitor for re-infection

## Resources

- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [Debian Security Manual](https://www.debian.org/doc/manuals/securing-debian-manual/)
- [Ubuntu Security Guide](https://ubuntu.com/security)

---

**Remember:** Security is not a one-time task, it's an ongoing process!

Last updated: $(date +%Y-%m-%d)
