#!/bin/bash

# System Update Script for Debian
# Automatically updates and upgrades the system with logging

# Configuration
LOG_DIR="/var/log/system-updates"
LOG_FILE="${LOG_DIR}/update-$(date +%Y-%m-%d_%H-%M-%S).log"
RETENTION_DAYS=30  # Keep logs for 30 days

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to log command output
run_command() {
    log_message "Running: $1"
    eval "$1" >> "$LOG_FILE" 2>&1
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        log_message "✓ Command completed successfully"
    else
        log_message "✗ Command failed with exit code: $exit_code"
    fi
    return $exit_code
}

# Start logging
log_message "========================================="
log_message "System Update Process Started"
log_message "========================================="
log_message "Hostname: $(hostname)"
log_message "User: $(whoami)"
log_message "========================================="

# Update package lists
log_message "Step 1: Updating package lists..."
run_command "apt-get update"

# Upgrade packages
log_message "Step 2: Upgrading installed packages..."
run_command "apt-get upgrade -y"

# Full upgrade (handles dependencies)
log_message "Step 3: Performing full upgrade..."
run_command "apt-get full-upgrade -y"

# Remove unnecessary packages
log_message "Step 4: Removing unnecessary packages..."
run_command "apt-get autoremove -y"

# Clean up package cache
log_message "Step 5: Cleaning package cache..."
run_command "apt-get autoclean"

# Check if reboot is required
if [ -f /var/run/reboot-required ]; then
    log_message "⚠ REBOOT REQUIRED!"
    log_message "Packages requiring reboot:"
    cat /var/run/reboot-required.pkgs >> "$LOG_FILE" 2>&1
else
    log_message "✓ No reboot required"
fi

# Display disk space
log_message "========================================="
log_message "Current disk usage:"
df -h / | tee -a "$LOG_FILE"

# Summary
log_message "========================================="
log_message "System Update Process Completed"
log_message "Log file: $LOG_FILE"
log_message "========================================="

# Clean up old logs
log_message "Cleaning up logs older than ${RETENTION_DAYS} days..."
find "$LOG_DIR" -name "update-*.log" -type f -mtime +${RETENTION_DAYS} -delete
log_message "Log cleanup completed"

# Create a symlink to latest log
ln -sf "$LOG_FILE" "${LOG_DIR}/latest.log"

# Send email notification
if command -v mail &> /dev/null; then
	echo "System update completed. See attached log | \
	mail -s "System update - $(hostname) - $(date +%Y-%m-%d)" \
		-A "$LOG_FILE" \
		Your email address
fi

exit 0
