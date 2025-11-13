# Linux SysAdmin Toolkit

A comprehensive collection of scripts, configurations, and automation tools for Linux system administration, built during my journey from network engineering to cybersecurity. This repository demonstrates practical infrastructure management skills with a focus on automation, security, and operational excellence.

👤 About Me
I'm an aspiring cybersecurity engineer with a strong foundation in networking and Linux system administration. My goal is to specialize in blue team operations and defensive security, and this repository represents my hands-on learning journey.
Background:

🌐 CCNA Certified - Strong understanding of networking fundamentals
🐧 LPIC-1 Certified - Solid Linux system administration skills
🐧 Certified in Cybersecurity- Solid understanding of Cybersecurity concepts
🛡️ Focused on Blue Team/Defensive Security
🎯 Career Path: Linux SysAdmin → Infrastructure Engineer → Cybersecurity Engineer

Why This Repository?
I believe the best way to learn is by doing. Rather than just studying theory, I'm building real infrastructure, automating tasks, documenting everything, and sharing it with the community. This repository serves as both my learning portfolio and a resource for others on similar paths.
🎯 Overview
This repository contains production-ready scripts and configurations developed while building practical system administration skills. Each tool addresses real-world infrastructure challenges with a security-first mindset.

What You'll Find Here:

🎯 Automated system maintenance with comprehensive logging
🎯 Security hardening configurations following CIS benchmarks
🎯 Monitoring and alerting solutions
🎯 Infrastructure as Code with Ansible
🎯 Detailed documentation and troubleshooting guides
🎯 Real-world examples from actual deployments

Target Audience:

🎯 Aspiring system administrators building foundational skills
🎯 Junior DevOps engineers learning automation
🎯 Students preparing for Linux certifications
🎯 Anyone interested in blue team security operations
🎯 Self-learners working on homelab projects

✨ Key Features

🔄 Automated System Maintenance: Self-documenting update scripts with systemd integration
🔒 Security-First Approach: Every configuration follows security best practices
📊 Monitoring & Logging: Comprehensive observability for infrastructure
🤖 Infrastructure as Code: Ansible playbooks for reproducible deployments
📝 Extensive Documentation: Each script includes detailed README and usage examples
🧪 Tested & Verified: All configurations tested on Debian-based systems
🛠️ Troubleshooting Guides: Solutions to common problems I've encountered
🎓 Learning Resources: Explanations of why, not just how

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
- [Repository Structure](#repository-structure)
- [Quick Start Examples](#quick-start-examples)
- [Categories](#categories)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Best Practices](#best-practices)
- [Contributing](#contributing)
- [Documentation](#documentation)
- [License](#license)
- [Author](#author)
- [Acknowledgments](#acknowledgments)

## 🎯 Overview

This repository contains production-ready scripts and configurations I've developed while learning and practicing Linux system administration. Each tool is documented, tested, and designed to solve real-world infrastructure challenges.

**Target Audience:**
- Junior system administrators building foundational skills
- DevOps engineers automating infrastructure tasks
- Anyone preparing for Linux administration roles
- Self-learners working on homelab projects

## ✨ Features

- 🔄 **Automated System Maintenance**: Update scripts, backup solutions, and health checks
- 🔒 **Security Hardening**: SSH configurations, firewall rules, and CIS benchmark implementations
- 📊 **Monitoring Solutions**: Prometheus, Grafana, and custom monitoring scripts
- 🤖 **Infrastructure as Code**: Ansible playbooks and Terraform configurations
- 📝 **Comprehensive Documentation**: Each script includes detailed README with usage examples
- 🧪 **Tested Configurations**: All scripts tested on Debian/Ubuntu and RHEL-based systems
- 🛠️ **Troubleshooting Guides**: Common issues and their solutions

## 🚀 Getting Started

### Prerequisites

- Linux system (Debian/Ubuntu or RHEL/CentOS recommended)
- Basic understanding of Linux command line
- Root or sudo access for system-level operations
- Git installed

### Quick Clone
```bash
git clone https://github.com/kayzfiq/linux-sysadmin-toolkit.git
cd linux-sysadmin-toolkit
```

## 📁 Repository Structure
```
linux-sysadmin-toolkit/
├── automation/           # Automation scripts for common tasks
├── configuration/        # System and service configuration files
├── playbooks/           # Ansible and Terraform configurations
├── monitoring/          # Monitoring and alerting setups
├── troubleshooting/     # Troubleshooting guides and solutions
├── docs/               # Additional documentation
└── examples/           # Real-world usage examples
```

## ⚡ Quick Start Examples

### 1. Automated System Updates

Deploy automatic system updates with systemd:
```bash
cd automation/system-updates
sudo cp system-update.sh /usr/local/bin/
sudo cp system-update.service /etc/systemd/system/
sudo cp system-update.timer /etc/systemd/system/
sudo systemctl enable --now system-update.timer
```

[See full documentation](automation/system-updates/README.md)

### 2. SSH Hardening

Secure your SSH configuration:
```bash
cd configuration/ssh-hardening
sudo ./setup.sh
```

[See full documentation](configuration/ssh-hardening/README.md)

### 3. Server Monitoring Setup

Deploy Prometheus and Grafana:
```bash
cd playbooks/ansible
ansible-playbook -i inventory/hosts server-monitoring.yml
```

[See full documentation](playbooks/ansible/README.md)

## 📚 Categories

### 🔄 Automation
- **System Updates**: Automated patching with logging and notifications
- **User Management**: Bulk user creation and management scripts
- **Backup Solutions**: Automated backup and restore scripts
- **Health Checks**: System health monitoring scripts

[Browse automation scripts →](automation/)

### 🔧 Configuration Management
- **SSH Hardening**: Secure SSH configurations following best practices
- **Firewall Rules**: UFW and iptables configuration scripts
- **Web Servers**: Nginx and Apache optimized configurations
- **Security Hardening**: CIS benchmark implementation scripts

[Browse configurations →](configuration/)

### 🤖 Infrastructure as Code
- **Ansible Playbooks**: Server provisioning and configuration management
- **Terraform**: Infrastructure deployment on cloud platforms
- **Docker Compose**: Containerized service deployments

[Browse IaC resources →](playbooks/)

### 📊 Monitoring & Logging
- **Prometheus**: Metrics collection configurations
- **Grafana**: Pre-built dashboards for system monitoring
- **Logging**: Centralized logging with rsyslog and logrotate

[Browse monitoring tools →](monitoring/)

### 🔍 Troubleshooting
- **Common Issues**: Solutions to frequently encountered problems
- **Performance Debugging**: Tools and techniques for performance analysis
- **Network Troubleshooting**: Network connectivity and diagnostic guides

[Browse troubleshooting guides →](troubleshooting/)

## 💻 Requirements

### Supported Distributions
- ✅ Debian 11/12
- ✅ Ubuntu 20.04/22.04/24.04
- ✅ Rocky Linux 8/9
- ✅ AlmaLinux 8/9
- ⚠️ Other distributions may work but are untested

### Software Dependencies
Varies by script, but commonly requires:
- Bash 4.0+
- systemd (for service management)
- sudo privileges
- Basic utilities: curl, wget, git

Specific requirements are listed in each section's README.

## 📦 Installation

Most scripts can be used directly, but some require setup:

### Option 1: Use Individual Scripts
```bash
# Navigate to desired script
cd automation/system-updates

# Make executable
chmod +x system-update.sh

# Run (with sudo if needed)
sudo ./system-update.sh
```

### Option 2: Install System-Wide
```bash
# Install all automation scripts to /usr/local/bin
sudo make install

# Or install specific category
cd automation && sudo make install
```

## 📖 Usage

Each directory contains its own README with:
- Detailed usage instructions
- Configuration options
- Examples
- Troubleshooting tips

Example workflow:
```bash
# 1. Navigate to the tool you need
cd automation/backup-scripts

# 2. Read the documentation
cat README.md

# 3. Configure the script (if needed)
nano backup-system.sh

# 4. Run it
sudo ./backup-system.sh
```

## 🎓 Best Practices

This repository follows these principles:

- ✅ **Security First**: All scripts follow security best practices
- ✅ **Idempotent**: Scripts can be run multiple times safely
- ✅ **Logging**: Comprehensive logging for troubleshooting
- ✅ **Error Handling**: Proper error checking and graceful failures
- ✅ **Documentation**: Every script is thoroughly documented
- ✅ **Tested**: Scripts are tested before committing

[Read full best practices guide →](docs/best-practices.md)

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Contribution Ideas
- Add new automation scripts
- Improve existing documentation
- Report bugs or security issues
- Share your use cases
- Translate documentation

## 📄 Documentation

Additional documentation available in the `docs/` directory:

- [Getting Started Guide](docs/getting-started.md)
- [Security Checklist](docs/security-checklist.md)
- [Disaster Recovery](docs/disaster-recovery.md)
- [Best Practices](docs/best-practices.md)

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Your Name**
- GitHub: [@kayzfiq](https://github.com/kayzfiq)
- LinkedIn: [My LinkedIn](https://linkedin.com/in/kaye.shafiq)
- Blog: [My Blog](https://kayzfiq.github.io)

##  Learning Journey

This repository is part of my journey to becoming a cybersecurity engineer. I'm documenting everything I learn about Linux system administration and infrastructure management.

**Certifications:**
- ✅ CCNA (Cisco Certified Network Associate)
- ✅ Certified in Cybersecurity (CC) ISC2
- ✅ LPIC-1 (Linux Professional Institute Certification)

**Currently Learning:**
- Blue Team Security Operations
- Security Information and Event Management (SIEM)
- Infrastructure Security Hardening

## 🙏 Acknowledgments

- Linux community for extensive documentation
- Security researchers for hardening guides
- Open source projects that inspired these tools
- Everyone who contributed feedback and suggestion

Looking for:

📞 Mentorship opportunities in cybersecurity
📞 Junior Linux SysAdmin positions
📞 SOC Analyst or Security Engineer roles
📞 Collaboration on security projects

## 📞 Support

If you found this repository helpful, please consider:
- ⭐ Starring the repository
- 🐛 Reporting bugs
- 💡 Suggesting new features
- 📝 Contributing improvements

**Questions?** Open an [issue](https://github.com/kayzfiq/linux-sysadmin-toolkit/issues) or reach out!

---

<p align="center">Made with ❤️ for the Linux community</p>
