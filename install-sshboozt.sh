#!/usr/bin/env bash
#========================================
# SSHboozt DEX Upgrade - Linux/WSL Installer
# Interactive SSH Configuration Suite
#========================================
# Author: David Mireles (@louzt)
# License: MIT
#========================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if running in WSL
is_wsl() {
    grep -qi microsoft /proc/version 2>/dev/null
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        echo -e "${RED}[ERROR] Do not run this script as root${NC}"
        echo "Run as regular user. Sudo will be requested when needed."
        exit 1
    fi
}

# Banner
show_banner() {
    clear
    echo -e "${CYAN}"
    echo "================================================"
    echo "    SSHboozt DEX Upgrade - Linux/WSL Installer"
    echo "================================================"
    echo -e "${NC}"
    echo "This installer will:"
    echo " [1] Install required dependencies"
    echo " [2] Backup your current SSH config"
    echo " [3] Deploy optimized SSH configurations"
    echo " [4] Setup development tools integration"
    echo ""
    echo "================================================"
    echo ""
}

# Detect OS
detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS=$ID
        OS_VERSION=$VERSION_ID
    else
        OS="unknown"
    fi
    
    if is_wsl; then
        echo -e "${BLUE}[DETECT] Running in WSL${NC}"
        WSL=true
    else
        echo -e "${BLUE}[DETECT] Running on native Linux${NC}"
        WSL=false
    fi
    
    echo -e "${BLUE}[DETECT] OS: $OS $OS_VERSION${NC}"
}

# Install dependencies
install_dependencies() {
    echo ""
    echo -e "${YELLOW}[DEPS] Checking dependencies...${NC}"
    echo ""
    
    local packages=()
    
    # Check for openssh-client
    if ! command -v ssh &> /dev/null; then
        packages+=("openssh-client")
    fi
    
    # Check for rsync (useful for file transfers)
    if ! command -v rsync &> /dev/null; then
        packages+=("rsync")
    fi
    
    # Check for netcat (for testing connections)
    if ! command -v nc &> /dev/null; then
        packages+=("netcat-openbsd")
    fi
    
    if [ ${#packages[@]} -eq 0 ]; then
        echo -e "${GREEN}[OK] All dependencies already installed${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}[INFO] Need to install: ${packages[*]}${NC}"
    echo ""
    
    read -p "Install missing packages? (Y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        case $OS in
            ubuntu|debian)
                echo -e "${BLUE}[INSTALL] Installing via apt...${NC}"
                sudo apt update
                sudo apt install -y "${packages[@]}"
                ;;
            fedora|rhel|centos)
                echo -e "${BLUE}[INSTALL] Installing via dnf/yum...${NC}"
                sudo dnf install -y "${packages[@]}" 2>/dev/null || sudo yum install -y "${packages[@]}"
                ;;
            arch|manjaro)
                echo -e "${BLUE}[INSTALL] Installing via pacman...${NC}"
                sudo pacman -S --noconfirm "${packages[@]}"
                ;;
            *)
                echo -e "${RED}[ERROR] Unsupported OS: $OS${NC}"
                echo "Please install manually: ${packages[*]}"
                return 1
                ;;
        esac
        
        echo -e "${GREEN}[OK] Dependencies installed${NC}"
    else
        echo -e "${YELLOW}[SKIP] Dependency installation skipped${NC}"
    fi
}

# Check SSH directory
check_ssh_dir() {
    SSH_DIR="$HOME/.ssh"
    
    if [[ ! -d "$SSH_DIR" ]]; then
        echo -e "${YELLOW}[INFO] Creating .ssh directory...${NC}"
        mkdir -p "$SSH_DIR"
        chmod 700 "$SSH_DIR"
        echo -e "${GREEN}[OK] Directory created: $SSH_DIR${NC}"
    fi
    
    # Check for SSH keys
    if [[ ! -f "$SSH_DIR/id_rsa" ]] && [[ ! -f "$SSH_DIR/id_ed25519" ]]; then
        echo ""
        echo -e "${YELLOW}[WARNING] No SSH keys found${NC}"
        echo ""
        read -p "Generate new SSH key pair? (Y/n): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
            echo ""
            read -p "Enter your email for key: " EMAIL
            ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_DIR/id_ed25519"
            echo -e "${GREEN}[OK] SSH key generated${NC}"
        fi
    fi
}

# Show current config
show_current_config() {
    echo ""
    echo -e "${BLUE}[SCAN] Checking current SSH configuration...${NC}"
    echo ""
    
    if [[ -f "$SSH_DIR/config" ]]; then
        echo -e "${GREEN}[FOUND] Existing SSH config detected${NC}"
        echo "Location: $SSH_DIR/config"
        echo ""
        echo -e "${CYAN}[PREVIEW] Current config (first 10 lines):${NC}"
        echo "----------------------------------------"
        head -n 10 "$SSH_DIR/config"
        echo "----------------------------------------"
        echo ""
    else
        echo -e "${YELLOW}[INFO] No existing SSH config found${NC}"
        echo "This is a fresh installation"
        echo ""
    fi
}

# Create backup
create_backup() {
    if [[ -f "$SSH_DIR/config" ]]; then
        BACKUP_DATE=$(date +%Y%m%d-%H%M%S)
        BACKUP_FILE="$SSH_DIR/config.backup-$BACKUP_DATE"
        
        echo -e "${BLUE}[BACKUP] Creating backup...${NC}"
        cp "$SSH_DIR/config" "$BACKUP_FILE"
        echo -e "${GREEN}[OK] Backup created: $BACKUP_FILE${NC}"
        echo ""
    fi
}

# Configuration menu
show_config_menu() {
    echo ""
    echo "================================================"
    echo " Select Your Configuration Profile"
    echo "================================================"
    echo ""
    echo "[1] Linux Native (Recommended)"
    echo "    - Full multiplexing support"
    echo "    - Best for: Native Linux, WSL2"
    echo "    - Stability: 100%"
    echo ""
    echo "[2] WSL Optimized (Windows Interop)"
    echo "    - Optimized for WSL2 + Windows"
    echo "    - Best for: WSL + VS Code Remote"
    echo "    - Includes Windows path translations"
    echo ""
    echo "[3] Minimal (No Multiplexing)"
    echo "    - Simple, stable config"
    echo "    - Best for: Testing, compatibility"
    echo "    - No advanced features"
    echo ""
    echo "[0] Exit Installer"
    echo ""
    read -p "Enter your choice (0-3): " CONFIG_CHOICE
}

# Install Linux native config
install_linux_native() {
    echo ""
    echo "================================================"
    echo " Installing Linux Native Configuration"
    echo "================================================"
    echo ""
    
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    CONFIG_SRC="$SCRIPT_DIR/config-examples/ssh_config_linux_multiplexing"
    
    if [[ ! -f "$CONFIG_SRC" ]]; then
        echo -e "${RED}[ERROR] Config file not found!${NC}"
        echo "Expected: $CONFIG_SRC"
        echo ""
        echo "Please run this script from the SSHboozt repository directory."
        return 1
    fi
    
    # Create sockets directory
    SOCKETS_DIR="$SSH_DIR/sockets"
    if [[ ! -d "$SOCKETS_DIR" ]]; then
        echo -e "${BLUE}[INFO] Creating sockets directory...${NC}"
        mkdir -p "$SOCKETS_DIR"
        chmod 700 "$SOCKETS_DIR"
    fi
    
    echo -e "${BLUE}[INSTALL] Copying configuration...${NC}"
    cp "$CONFIG_SRC" "$SSH_DIR/config"
    chmod 600 "$SSH_DIR/config"
    
    echo -e "${GREEN}[OK] Configuration installed successfully${NC}"
    echo ""
    echo -e "${YELLOW}[INFO] Please customize your config:${NC}"
    echo ""
    echo "Edit: $SSH_DIR/config"
    echo ""
    echo "Replace these values:"
    echo " - 167.88.38.25 -> Your VPS IP"
    echo " - root -> Your SSH username"
    echo " - ~/.ssh/id_rsa -> Your SSH key path"
    echo ""
    
    read -p "Edit config now? (Y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        ${EDITOR:-nano} "$SSH_DIR/config"
    fi
    
    return 0
}

# Install WSL optimized config
install_wsl_optimized() {
    echo ""
    echo "================================================"
    echo " Installing WSL Optimized Configuration"
    echo "================================================"
    echo ""
    
    if ! is_wsl; then
        echo -e "${YELLOW}[WARNING] Not running in WSL${NC}"
        echo "This config is optimized for WSL2 + Windows interop"
        echo ""
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 1
        fi
    fi
    
    # Use Linux config as base (works well in WSL2)
    install_linux_native
    
    # Add WSL-specific optimizations
    echo ""
    echo -e "${BLUE}[WSL] Adding WSL-specific optimizations...${NC}"
    
    # Check if wsl.conf exists
    WSL_CONF="/etc/wsl.conf"
    if [[ -f "$WSL_CONF" ]]; then
        echo -e "${GREEN}[OK] WSL config found: $WSL_CONF${NC}"
    else
        echo -e "${YELLOW}[INFO] No wsl.conf found${NC}"
        echo "Consider creating /etc/wsl.conf for better performance"
    fi
    
    # Suggest systemd if not enabled
    if ! systemctl --version &>/dev/null; then
        echo ""
        echo -e "${YELLOW}[TIP] Enable systemd in WSL for better SSH agent management${NC}"
        echo "Add to /etc/wsl.conf:"
        echo ""
        echo "[boot]"
        echo "systemd=true"
        echo ""
    fi
    
    return 0
}

# Install minimal config
install_minimal() {
    echo ""
    echo "================================================"
    echo " Installing Minimal Configuration"
    echo "================================================"
    echo ""
    
    echo -e "${BLUE}[INSTALL] Creating minimal config...${NC}"
    
    cat > "$SSH_DIR/config" << 'EOF'
# SSHboozt - Minimal Configuration
# No multiplexing, maximum compatibility

Host *
    # Disable multiplexing
    ControlMaster no
    ControlPath none
    ControlPersist no
    
    # Keep connections alive
    ServerAliveInterval 60
    ServerAliveCountMax 3
    
    # Modern security
    HostKeyAlgorithms ssh-ed25519,rsa-sha2-512,rsa-sha2-256
    KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org
    
    # Compression
    Compression yes
    
    # Reuse connections
    TCPKeepAlive yes
    
    # Speed up initial connection
    GSSAPIAuthentication no

# Example host configuration
# Host my-server
#     HostName example.com
#     User myuser
#     IdentityFile ~/.ssh/id_ed25519
#     Port 22
EOF
    
    chmod 600 "$SSH_DIR/config"
    
    echo -e "${GREEN}[OK] Minimal config created${NC}"
    echo ""
    echo -e "${YELLOW}[INFO] Please add your server configurations${NC}"
    echo ""
    
    read -p "Edit config now? (Y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        ${EDITOR:-nano} "$SSH_DIR/config"
    fi
    
    return 0
}

# Test SSH config
test_ssh_config() {
    echo ""
    echo -e "${BLUE}[TEST] Validating SSH configuration...${NC}"
    
    if ssh -G localhost &>/dev/null; then
        echo -e "${GREEN}[OK] SSH config syntax is valid${NC}"
    else
        echo -e "${RED}[ERROR] SSH config has syntax errors${NC}"
        echo "Run: ssh -G localhost"
        return 1
    fi
    
    echo ""
    echo -e "${CYAN}[INFO] SSH client version:${NC}"
    ssh -V
    
    return 0
}

# Setup VS Code integration
setup_vscode() {
    echo ""
    echo -e "${BLUE}[VSCODE] Checking VS Code integration...${NC}"
    
    if command -v code &> /dev/null; then
        echo -e "${GREEN}[OK] VS Code CLI found${NC}"
        
        echo ""
        read -p "Install VS Code Remote-SSH extension? (Y/n): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
            code --install-extension ms-vscode-remote.remote-ssh
            echo -e "${GREEN}[OK] Remote-SSH extension installed${NC}"
        fi
    else
        echo -e "${YELLOW}[INFO] VS Code not found in PATH${NC}"
        
        if is_wsl; then
            echo ""
            echo "To use VS Code from WSL:"
            echo " 1. Install VS Code on Windows"
            echo " 2. Install 'Remote - WSL' extension"
            echo " 3. Run: code . (from WSL)"
        fi
    fi
}

# Installation complete
installation_complete() {
    echo ""
    echo "================================================"
    echo " Installation Complete!"
    echo "================================================"
    echo ""
    echo -e "${GREEN}[SUCCESS] SSHboozt has been installed${NC}"
    echo ""
    echo "Next steps:"
    echo " 1. Test your SSH connection:"
    echo "    ssh your-server"
    echo ""
    echo " 2. Check connection speed:"
    echo "    time ssh your-server exit"
    echo ""
    echo " 3. View multiplexing status:"
    echo "    ssh -O check your-server"
    echo ""
    echo " 4. Read the docs:"
    echo "    - docs/multiplexing.md"
    echo "    - docs/troubleshooting.md"
    echo "    - docs/alternatives.md"
    echo ""
    echo "================================================"
    echo ""
}

# Main execution
main() {
    check_root
    show_banner
    detect_os
    install_dependencies
    check_ssh_dir
    show_current_config
    create_backup
    show_config_menu
    
    case $CONFIG_CHOICE in
        1)
            install_linux_native
            ;;
        2)
            install_wsl_optimized
            ;;
        3)
            install_minimal
            ;;
        0)
            echo ""
            echo -e "${YELLOW}[EXIT] Installation cancelled${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}[ERROR] Invalid choice: $CONFIG_CHOICE${NC}"
            exit 1
            ;;
    esac
    
    if [[ $? -eq 0 ]]; then
        test_ssh_config
        setup_vscode
        installation_complete
    fi
}

# Run main function
main
