#!/bin/bash

# ============================================================================
# Advanced User Management Script
# Author: Kayzfiq
# Features: Create single/bulk users, lock/unlock, reset password, audit users,
#           delete users, enforce password policy, full logging.
# Requires: root privileges
# ==============================================================================

# Colors for better UX
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No color

# Variables 
LOG_FILE="/var/log/user_management.log"
BULK_FILE="/tmp/bulk_users.csv"  # Temporary location for bulk user file
BACKUP_DIR="/var/backups/user_homes"

# Check root privileges
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}This script must be run as root user!${NC}"
    exit 1
fi

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $(whoami) | $1" >> "$LOG_FILE"
}

# Create log file and backup dir if they don't exist and set permissions
[[ ! -f "$LOG_FILE" ]] && touch "$LOG_FILE" && chmod 640 "$LOG_FILE"
[[ ! -d "$BACKUP_DIR" ]] && mkdir -p "$BACKUP_DIR" && chmod 700 "$BACKUP_DIR"

# ==========================================================================
# 1. Create a single user
# ==========================================================================
create_user() {
    read -p "Enter username: " username
    if id "$username" &>/dev/null; then
        echo -e "${RED}User $username already exists!${NC}"
        log_action "FAILED to create user $username - already exists"
        return 1
    fi

    read -p "Enter full name (optional): " fullname
    read -p "Set password? (y/n): " setpass
    
    # Create user first
    useradd -m -c "${fullname:-$username}" "$username" 2>/dev/null || useradd -m "$username"
    
    if [[ "$setpass" =~ ^[Yy]$ ]]; then
        passwd "$username"
    else
        # Generate random password
        newpass=$(openssl rand -base64 12)
        echo "$username:$newpass" | chpasswd
        echo -e "${YELLOW}Random password set: $newpass${NC}"
        echo -e "${YELLOW}IMPORTANT: Save this password! It won't be shown again.${NC}"
    fi

    echo -e "${GREEN}User $username created successfully!${NC}"
    log_action "CREATED user $username"
}

# ===================================================================================
# 2. Bulk create users from a file
# Format: username,password,fullname,groups(optional)
# Example: john,Pass123!,John Doe,developers,sudo
# ===================================================================================
bulk_create_users() {
    echo "Place your CSV file at: $BULK_FILE"
    echo "Format: username,password,fullname,groups (groups optional)"
    read -p "Press Enter when file is ready, or 'q' to quit: " ready
    [[ "$ready" =~ ^[Qq]$ ]] && return

    if [[ ! -f "$BULK_FILE" ]]; then
        echo -e "${RED}File $BULK_FILE not found!${NC}"
        return 1
    fi

    local success=0
    local failed=0

    while IFS=, read -r username password fullname groups || [[ -n $username ]]; do
        # Skip empty lines and comments
        [[ -z "$username" || "$username" =~ ^# ]] && continue

        if id "$username" &>/dev/null; then
            echo -e "${YELLOW}SKIP: $username already exists${NC}"
            ((failed++))
            continue
        fi

        # Create user
        useradd -m -c "$fullname" -s /bin/bash "$username" 2>/dev/null
        echo "$username:$password" | chpasswd

        # Add to additional groups if specified
        if [[ -n "$groups" ]]; then
            usermod -aG ${groups// /,} "$username"
        fi

        echo -e "${GREEN}Created: $username${NC}"
        log_action "BULK CREATED user $username"
        ((success++))
    done < "$BULK_FILE"

    echo -e "${BLUE}Bulk operation complete: $success created, $failed skipped${NC}"
    log_action "BULK CREATE completed: $success success, $failed failed"
}

# ==================================================================================
# 3. Lock user account
# ==================================================================================
lock_user() {
    read -p "Enter username to lock: " username
    if ! id "$username" &>/dev/null; then
        echo -e "${RED}User $username does not exist!${NC}"
        return 1
    fi

    passwd -l "$username" >/dev/null
    usermod -L "$username" 2>/dev/null
    echo -e "${GREEN}User $username has been LOCKED${NC}"
    log_action "LOCKED user $username"
}

# ================================================================================
# 4. Unlock user account
# ================================================================================
unlock_user() {
    read -p "Enter username to unlock: " username
    if ! id "$username" &>/dev/null; then
        echo -e "${RED}User $username does not exist!${NC}"
        return 1
    fi

    passwd -u "$username" >/dev/null
    usermod -U "$username" 2>/dev/null
    echo -e "${GREEN}User $username has been unlocked${NC}"
    log_action "UNLOCKED user $username successfully"
}

# ================================================================================
# 5. Reset user password
# ================================================================================
reset_password() {
    read -p "Enter username: " username
    if ! id "$username" &>/dev/null; then
        echo -e "${RED}User $username does not exist!${NC}"
        return 1     
    fi

    echo "Setting new password for $username"
    passwd "$username"
    log_action "PASSWORD RESET for user $username"
    echo -e "${GREEN}Password reset successful!${NC}"
}

# ===============================================================================
# 6. Audit users (Very useful!)
# ===============================================================================
audit_users() {
    echo -e "${BLUE}=== SYSTEM USER AUDIT ===${NC}"
    echo "Last login information:"
    last -10 | head -20
    echo
    echo "Users with login shell:"
    awk -F: '$7 ~ /\/bash|\/sh|\/zsh/ {print $1 " UID:" $3 " Home:" $6}' /etc/passwd | sort
    echo
    echo "Users with root privileges:"
    awk -F: '$3 == 0 {print $1}' /etc/passwd
    echo
    echo "Password expiration summary:"
    echo "User                Expires                Status"
    echo "------------------------------------------------------------"
    while read -r user; do
        status=$(chage -l "$user" 2>/dev/null | grep "Password expires" | awk -F: '{print $2}' | xargs)
        [[ "$status" == "never" ]] && status="Never expires"
        printf "%-18s %-20s\n" "$user" "$status"
    done < <(getent passwd | cut -d: -f1 | grep -vE "^(root|daemon|bin|sys)") 
    log_action "AUDIT performed by $(whoami)"
}

# =================================================================================
# 7. List Active (recently logged in) Users
# =================================================================================
list_active_users() {
    echo -e "${BLUE}=== Recently Active Users (last 30 days) ===${NC}"
    lastlog --time 30 | grep -v "Never logged in" | grep -v "Username" | awk '{print $1}' | sort -u
}

# ================================================================================
# 8. List Regular Users
# ================================================================================
list_regular_users() {
    echo -e "${BLUE}=== All Regular Users (UID >=1000) ===${NC}"
    getent passwd | awk -F: '$3 >= 1000 && $3 < 60000 {printf "%-20s UID:%-6s %s\n", $1, $3, $5}'
}

# =================================================================================
# 9. Delete user (Safe with backup)
# =================================================================================
delete_user() {
    read -p "Enter username to delete: " username
    if ! id "$username" &>/dev/null; then
        echo -e "${RED}User $username does not exist!${NC}"
        return 1
    fi

    echo
    echo -e "${YELLOW}WARNING: This will permanently delete the user: $username${NC}"
    echo "Home directory: $(getent passwd "$username" | cut -d: -f6)"
    echo "UID: $(id -u "$username")"
    read -p "Type username to confirm deletion: " confirm

    if [[ "$confirm" != "$username" ]]; then
        echo -e "${RED}Confirmation failed. Aborted.${NC}"
        return 1
    fi

    # Backup home directory
    homedir=$(getent passwd "$username" | cut -d: -f6)
    if [[ -d "$homedir" && "$homedir" != "/" ]]; then
        backup_name="${username}_home_$(date +%Y%m%d_%H%M%S).tar.gz"
        echo -e "${YELLOW}Backing up home directory to $BACKUP_DIR/$backup_name ...${NC}"
        tar -czf "$BACKUP_DIR/$backup_name" -C "$(dirname "$homedir")" "$(basename "$homedir")" 2>/dev/null
    fi

    # Kill user processes
    pkill -u "$username" 2>/dev/null

    # Delete user and home directory
    userdel -r "$username" 2>/dev/null
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}User $username has been DELETED${NC}"
        echo -e "${BLUE}Home backup saved: $BACKUP_DIR/$backup_name${NC}"
        log_action "DELETED user $username (home backed up)"
    else
        echo -e "${RED}Failed to delete user $username${NC}"
        log_action "FAILED to delete user $username"
    fi
}

# ==================================================================================
# 10. Enforce Strong Password Policy (System-wide)
# Uses pam_pwquality (recommended on RHEL/CentOS/Ubuntu)
# ==================================================================================
enforce_password_policy() {
    echo -e "${BLUE}Configuring Strong Password Policy (pam_pwquality)${NC}"

    # Install pam_pwquality if missing
    if ! dpkg -l | grep -q libpam-pwquality && ! rpm -q pam_pwquality &>/dev/null; then
        echo "Installing pam_pwquality..."
        if command -v apt-get &>/dev/null; then
            apt-get update && apt-get install -y libpam-pwquality
        elif command -v yum &>/dev/null; then
            yum install -y pam_pwquality
        elif command -v dnf &>/dev/null; then
            dnf install -y pam_pwquality
        fi
    fi

    # Backup original config file
    cp /etc/pam.d/common-password /etc/pam.d/common-password.bak.$(date +%F) 2>/dev/null

    # Configure strong policy
    cat > /etc/security/pwquality.conf << "EOF"
# Strong password policy - Enforced by User Management Script
minlen = 12
dcredit = -1  # at least 1 digit
ucredit = -1  # at least 1 uppercase letter
ocredit = -1  # at least 1 special character
lcredit = -1  # at least 1 lowercase letter
maxrepeat = 2
usercheck = 0
difok = 7
enforce_for_root = yes
EOF

    # Update PAM config (Debian/Ubuntu style)
    if [[ -f /etc/pam.d/common-password ]]; then
        sed -i "/pam_pwquality/ d" /etc/pam.d/common-password
        sed -i "/password.*requisite.*pam_pwquality.so/ d" /etc/pam.d/common-password
        grep -q "pam_pwquality.so" /etc/pam.d/common-password || \
            sed -i "/password.*pam_unix.so/ a password requisite pam_pwquality.so retry=3" /etc/pam.d/common-password
    fi

    # RHEL/CentOS style
    if [[ -f /etc/pam.d/password-auth ]]; then
        authselect enable-feature with-pwquality 2>/dev/null || true
    fi

    echo -e "${GREEN}Strong password policy ENFORCED system-wide!${NC}"
    echo "Rules: 12+ chars, 1 upper, 1 lower, 1 digit, 1 special, max 2 repeating chars"
    log_action "ENFORCED strong password policy (pam_pwquality)"
}

# =================================================================================
# 11. View Log
# =================================================================================
view_log() {
    if [[ ! -f "$LOG_FILE" ]]; then
        echo -e "${YELLOW}No log file found yet.${NC}"
        return
    fi
    
    echo -e "${BLUE}=== User Management Log (Last 50 entries) ===${NC}"
    tail -50 "$LOG_FILE"
    echo
    read -p "Press Enter to continue..."
}

# =================================================================================
# Menu
# =================================================================================
show_menu() {
    clear
    echo -e "${YELLOW}=================================================${NC}"
    echo -e "${BLUE}       ULTIMATE USER MANAGEMENT TOOL${NC}"
    echo -e "${YELLOW}=================================================${NC}"
    echo "1.  Create single user"
    echo "2.  Bulk create users from CSV file"
    echo "3.  Lock User Account"
    echo "4.  Unlock User Account"
    echo "5.  Reset password"
    echo "6.  Audit Users (security check)"
    echo "7.  List Active Users"
    echo "8.  List All Regular Users"
    echo "9.  Delete a User (with Backup)"
    echo "10. Enforce Strong Password Policy"
    echo "11. View Log"
    echo "0.  Exit"
    echo -e "${YELLOW}=================================================${NC}"
    read -p "Select an option: " choice
}

# ==================================================================================
# Main Loop
# ==================================================================================
while true; do
    show_menu
    case $choice in
        1) create_user; read -p "Press Enter..." ;;
        2) bulk_create_users; read -p "Press Enter..." ;;
        3) lock_user; read -p "Press Enter..." ;;
        4) unlock_user; read -p "Press Enter..." ;;
        5) reset_password; read -p "Press Enter..." ;;
        6) audit_users; read -p "Press Enter..." ;;
        7) list_active_users; read -p "Press Enter..." ;;
        8) list_regular_users; read -p "Press Enter..." ;;
        9) delete_user; read -p "Press Enter..." ;;
        10) enforce_password_policy; read -p "Press Enter..." ;;
        11) view_log ;;
        0) echo -e "${GREEN}See you, admin!${NC}"; log_action "Script exited"; exit 0 ;;
        *) echo -e "${RED}Invalid choice!${NC}"; sleep 1 ;;
    esac
done
