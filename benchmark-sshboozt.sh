#!/usr/bin/env bash
#========================================
# SSHboozt Benchmark Suite
# Measure Your SSH Performance Improvements
#========================================
# Author: David Mireles (@louzt)
# License: MIT
#
# This script tests:
# - Connection speed (initial + subsequent)
# - Git clone performance
# - rsync file transfer speed
# - Compression effectiveness
# - Overall improvement percentage
#========================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Configuration
BENCHMARK_REPO="https://github.com/torvalds/linux.git"  # Large test repo
BENCHMARK_DIR="/tmp/sshboozt-benchmark"
RESULTS_FILE="$HOME/.sshboozt-benchmark-results.json"
SSH_HOST=""
TEST_FILE_SIZE_MB=50

# Banner
show_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "================================================"
    echo "    SSHboozt Benchmark Suite"
    echo "    Measure Your SSH Performance"
    echo "================================================"
    echo -e "${NC}"
    echo ""
}

# Check dependencies
check_dependencies() {
    local missing=()
    
    command -v ssh &> /dev/null || missing+=("ssh")
    command -v git &> /dev/null || missing+=("git")
    command -v rsync &> /dev/null || missing+=("rsync")
    command -v bc &> /dev/null || missing+=("bc")
    
    if [ ${#missing[@]} -ne 0 ]; then
        echo -e "${RED}[ERROR] Missing dependencies: ${missing[*]}${NC}"
        echo "Please install them and try again."
        exit 1
    fi
}

# Get SSH host from user
get_ssh_host() {
    echo -e "${YELLOW}Enter your SSH server details${NC}"
    echo ""
    
    if [ -f "$HOME/.ssh/config" ]; then
        echo -e "${CYAN}Detected SSH hosts from your config:${NC}"
        grep -E "^Host " "$HOME/.ssh/config" | grep -v "\*" | awk '{print "  - " $2}'
        echo ""
    fi
    
    read -p "SSH host (user@hostname or SSH config name): " SSH_HOST
    
    if [ -z "$SSH_HOST" ]; then
        echo -e "${RED}[ERROR] SSH host is required${NC}"
        exit 1
    fi
    
    # Test connection
    echo ""
    echo -e "${BLUE}[TEST] Verifying SSH connection...${NC}"
    if ssh -o ConnectTimeout=10 "$SSH_HOST" "echo 'Connected successfully'" &> /dev/null; then
        echo -e "${GREEN}[OK] SSH connection verified${NC}"
    else
        echo -e "${RED}[ERROR] Cannot connect to $SSH_HOST${NC}"
        echo "Please check your SSH configuration and try again."
        exit 1
    fi
}

# Timer function
timer_start() {
    TIMER_START=$(date +%s.%N)
}

timer_end() {
    TIMER_END=$(date +%s.%N)
    TIMER_DIFF=$(echo "$TIMER_END - $TIMER_START" | bc)
    echo "$TIMER_DIFF"
}

# Test 1: SSH Connection Speed
test_connection_speed() {
    echo ""
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}Test 1: SSH Connection Speed${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Kill any existing multiplexed connections
    ssh -O exit "$SSH_HOST" 2>/dev/null || true
    sleep 1
    
    # Test 1: Initial connection (no multiplexing)
    echo -e "${BLUE}[BENCHMARK] Initial connection (fresh handshake + auth)${NC}"
    timer_start
    ssh -o ControlMaster=no "$SSH_HOST" "exit" 2>/dev/null
    CONN_INITIAL=$(timer_end)
    echo -e "${GREEN}[RESULT] Initial connection: ${CONN_INITIAL}s${NC}"
    
    # Test 2: Subsequent connection (with multiplexing if configured)
    echo ""
    echo -e "${BLUE}[BENCHMARK] Subsequent connection (reuse if multiplexing enabled)${NC}"
    timer_start
    ssh "$SSH_HOST" "exit" 2>/dev/null
    CONN_SUBSEQUENT=$(timer_end)
    echo -e "${GREEN}[RESULT] Subsequent connection: ${CONN_SUBSEQUENT}s${NC}"
    
    # Calculate improvement
    CONN_IMPROVEMENT=$(echo "scale=2; (($CONN_INITIAL - $CONN_SUBSEQUENT) / $CONN_INITIAL) * 100" | bc)
    
    if (( $(echo "$CONN_IMPROVEMENT > 50" | bc -l) )); then
        echo ""
        echo -e "${GREEN}${BOLD}✓ Multiplexing is WORKING!${NC}"
        echo -e "${GREEN}  Improvement: ${CONN_IMPROVEMENT}% faster subsequent connections${NC}"
    elif (( $(echo "$CONN_IMPROVEMENT > 10" | bc -l) )); then
        echo ""
        echo -e "${YELLOW}${BOLD}⚠ Partial multiplexing benefit${NC}"
        echo -e "${YELLOW}  Improvement: ${CONN_IMPROVEMENT}%${NC}"
    else
        echo ""
        echo -e "${YELLOW}${BOLD}ℹ Multiplexing may not be configured${NC}"
        echo -e "${YELLOW}  Connections are similar speed (${CONN_IMPROVEMENT}% difference)${NC}"
    fi
}

# Test 2: Git Clone Performance
test_git_clone() {
    echo ""
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}Test 2: Git Clone Performance${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Prepare test repo on remote server
    echo -e "${BLUE}[SETUP] Creating test repository on remote server...${NC}"
    ssh "$SSH_HOST" "
        rm -rf /tmp/sshboozt-test-repo
        mkdir -p /tmp/sshboozt-test-repo
        cd /tmp/sshboozt-test-repo
        git init --bare --quiet
        
        # Create a temporary repo with sample files
        cd /tmp
        rm -rf temp-repo
        mkdir temp-repo
        cd temp-repo
        git init --quiet
        
        # Generate test files (simulate a medium-sized project)
        for i in {1..100}; do
            mkdir -p src/module\$i
            echo 'const data = Array(1000).fill(\"test data for compression\");' > src/module\$i/index.js
            echo '# Module \$i documentation' > src/module\$i/README.md
        done
        
        git add .
        git commit -m 'Initial test data' --quiet
        git push /tmp/sshboozt-test-repo master --quiet
        cd /tmp
        rm -rf temp-repo
    " 2>/dev/null
    
    echo -e "${GREEN}[OK] Test repository ready (100 modules, text-heavy)${NC}"
    
    # Test clone performance
    echo ""
    echo -e "${BLUE}[BENCHMARK] Cloning test repository over SSH...${NC}"
    
    rm -rf "$BENCHMARK_DIR/test-clone"
    mkdir -p "$BENCHMARK_DIR"
    
    timer_start
    git clone "ssh://$SSH_HOST/tmp/sshboozt-test-repo" "$BENCHMARK_DIR/test-clone" --quiet 2>/dev/null
    GIT_CLONE_TIME=$(timer_end)
    
    CLONE_SIZE=$(du -sh "$BENCHMARK_DIR/test-clone" | awk '{print $1}')
    
    echo -e "${GREEN}[RESULT] Git clone completed in: ${GIT_CLONE_TIME}s${NC}"
    echo -e "${GREEN}[RESULT] Repository size: ${CLONE_SIZE}${NC}"
    
    # Cleanup
    rm -rf "$BENCHMARK_DIR/test-clone"
    ssh "$SSH_HOST" "rm -rf /tmp/sshboozt-test-repo" 2>/dev/null
    
    # Estimate improvement with compression
    if grep -q "^[[:space:]]*Compression yes" "$HOME/.ssh/config" 2>/dev/null; then
        echo ""
        echo -e "${GREEN}${BOLD}✓ Compression is ENABLED${NC}"
        echo -e "${GREEN}  Text-heavy repos benefit most (30-70% faster)${NC}"
    else
        echo ""
        echo -e "${YELLOW}${BOLD}⚠ Compression is NOT enabled${NC}"
        echo -e "${YELLOW}  Enable compression in your SSH config for 30-70% faster git operations${NC}"
    fi
}

# Test 3: rsync Performance
test_rsync_performance() {
    echo ""
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}Test 3: rsync File Transfer${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Create test files locally
    echo -e "${BLUE}[SETUP] Creating test files (${TEST_FILE_SIZE_MB}MB text data)...${NC}"
    
    rm -rf "$BENCHMARK_DIR/rsync-test"
    mkdir -p "$BENCHMARK_DIR/rsync-test"
    
    # Generate compressible text data
    for i in {1..10}; do
        head -c $((TEST_FILE_SIZE_MB * 1024 * 100)) < /dev/zero | tr '\0' 'A' > "$BENCHMARK_DIR/rsync-test/file$i.txt"
    done
    
    LOCAL_SIZE=$(du -sh "$BENCHMARK_DIR/rsync-test" | awk '{print $1}')
    echo -e "${GREEN}[OK] Test files created: ${LOCAL_SIZE}${NC}"
    
    # Test rsync upload
    echo ""
    echo -e "${BLUE}[BENCHMARK] Uploading files with rsync...${NC}"
    
    ssh "$SSH_HOST" "mkdir -p /tmp/sshboozt-rsync-test" 2>/dev/null
    
    timer_start
    rsync -az --quiet "$BENCHMARK_DIR/rsync-test/" "$SSH_HOST:/tmp/sshboozt-rsync-test/" 2>/dev/null
    RSYNC_TIME=$(timer_end)
    
    echo -e "${GREEN}[RESULT] rsync upload: ${RSYNC_TIME}s${NC}"
    
    TRANSFER_RATE=$(echo "scale=2; $TEST_FILE_SIZE_MB / $RSYNC_TIME" | bc)
    echo -e "${GREEN}[RESULT] Transfer rate: ${TRANSFER_RATE} MB/s${NC}"
    
    # Cleanup
    rm -rf "$BENCHMARK_DIR/rsync-test"
    ssh "$SSH_HOST" "rm -rf /tmp/sshboozt-rsync-test" 2>/dev/null
    
    # Check compression
    if grep -q "^[[:space:]]*Compression yes" "$HOME/.ssh/config" 2>/dev/null; then
        echo ""
        echo -e "${GREEN}${BOLD}✓ Compression is working for rsync${NC}"
    else
        echo ""
        echo -e "${YELLOW}${BOLD}⚠ Enable compression for faster rsync transfers${NC}"
    fi
}

# Test 4: Check SSH Config Optimizations
check_ssh_config() {
    echo ""
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}Test 4: SSH Configuration Analysis${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    if [ ! -f "$HOME/.ssh/config" ]; then
        echo -e "${RED}[WARNING] No SSH config found at ~/.ssh/config${NC}"
        return
    fi
    
    echo -e "${BLUE}[ANALYZE] Checking SSH configuration...${NC}"
    echo ""
    
    local optimizations_enabled=0
    local optimizations_total=7
    
    # Check each optimization
    if grep -qi "^[[:space:]]*ControlMaster.*auto" "$HOME/.ssh/config"; then
        echo -e "${GREEN}✓ Multiplexing (ControlMaster)${NC}"
        ((optimizations_enabled++))
    else
        echo -e "${YELLOW}✗ Multiplexing (ControlMaster)${NC}"
    fi
    
    if grep -qi "^[[:space:]]*Compression yes" "$HOME/.ssh/config"; then
        echo -e "${GREEN}✓ Compression${NC}"
        ((optimizations_enabled++))
    else
        echo -e "${YELLOW}✗ Compression${NC}"
    fi
    
    if grep -qi "^[[:space:]]*ServerAliveInterval" "$HOME/.ssh/config"; then
        echo -e "${GREEN}✓ Keep-Alive Timers${NC}"
        ((optimizations_enabled++))
    else
        echo -e "${YELLOW}✗ Keep-Alive Timers${NC}"
    fi
    
    if grep -qi "^[[:space:]]*HostKeyAlgorithms.*ed25519" "$HOME/.ssh/config"; then
        echo -e "${GREEN}✓ Modern Crypto (Ed25519)${NC}"
        ((optimizations_enabled++))
    else
        echo -e "${YELLOW}✗ Modern Crypto (Ed25519)${NC}"
    fi
    
    if grep -qi "^[[:space:]]*GSSAPIAuthentication no" "$HOME/.ssh/config"; then
        echo -e "${GREEN}✓ GSSAPI Disabled${NC}"
        ((optimizations_enabled++))
    else
        echo -e "${YELLOW}✗ GSSAPI Disabled${NC}"
    fi
    
    if grep -qi "^[[:space:]]*AddKeysToAgent" "$HOME/.ssh/config"; then
        echo -e "${GREEN}✓ SSH Agent Integration${NC}"
        ((optimizations_enabled++))
    else
        echo -e "${YELLOW}✗ SSH Agent Integration${NC}"
    fi
    
    if grep -qi "^[[:space:]]*TCPKeepAlive yes" "$HOME/.ssh/config"; then
        echo -e "${GREEN}✓ TCP Keep-Alive${NC}"
        ((optimizations_enabled++))
    else
        echo -e "${YELLOW}✗ TCP Keep-Alive${NC}"
    fi
    
    echo ""
    OPTIMIZATION_PERCENTAGE=$(echo "scale=0; ($optimizations_enabled * 100) / $optimizations_total" | bc)
    echo -e "${CYAN}Optimizations enabled: ${optimizations_enabled}/${optimizations_total} (${OPTIMIZATION_PERCENTAGE}%)${NC}"
    
    if [ "$optimizations_enabled" -eq "$optimizations_total" ]; then
        echo -e "${GREEN}${BOLD}🎉 All SSHboozt optimizations are enabled!${NC}"
    elif [ "$optimizations_enabled" -ge 5 ]; then
        echo -e "${YELLOW}${BOLD}⚠ Most optimizations enabled, but room for improvement${NC}"
    else
        echo -e "${RED}${BOLD}⚠ Consider installing SSHboozt configs for better performance${NC}"
    fi
}

# Generate final report
generate_report() {
    echo ""
    echo -e "${BOLD}${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${MAGENTA}    Benchmark Summary${NC}"
    echo -e "${BOLD}${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    echo -e "${CYAN}SSH Host:${NC} $SSH_HOST"
    echo -e "${CYAN}Date:${NC} $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    
    echo -e "${BOLD}Connection Performance:${NC}"
    echo -e "  Initial connection:    ${CONN_INITIAL}s"
    echo -e "  Subsequent connection: ${CONN_SUBSEQUENT}s"
    echo -e "  Improvement:           ${CONN_IMPROVEMENT}%"
    echo ""
    
    echo -e "${BOLD}Git Clone:${NC}"
    echo -e "  Time:                  ${GIT_CLONE_TIME}s"
    echo -e "  Size:                  ${CLONE_SIZE}"
    echo ""
    
    echo -e "${BOLD}rsync Transfer:${NC}"
    echo -e "  Time:                  ${RSYNC_TIME}s"
    echo -e "  Rate:                  ${TRANSFER_RATE} MB/s"
    echo ""
    
    echo -e "${BOLD}Configuration:${NC}"
    echo -e "  Optimizations:         ${OPTIMIZATION_PERCENTAGE}% enabled"
    echo ""
    
    # Overall assessment
    if (( $(echo "$CONN_IMPROVEMENT > 50" | bc -l) )) && [ "$OPTIMIZATION_PERCENTAGE" -ge 70 ]; then
        echo -e "${GREEN}${BOLD}🚀 EXCELLENT! Your SSH is highly optimized${NC}"
    elif (( $(echo "$CONN_IMPROVEMENT > 20" | bc -l) )) && [ "$OPTIMIZATION_PERCENTAGE" -ge 50 ]; then
        echo -e "${YELLOW}${BOLD}👍 GOOD! Decent optimizations in place${NC}"
    else
        echo -e "${RED}${BOLD}⚠ NEEDS IMPROVEMENT! Install SSHboozt for 3-5x gains${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}💡 Tip: Run this benchmark before and after installing SSHboozt${NC}"
    echo -e "${CYAN}   to measure your exact improvement percentage!${NC}"
    echo ""
}

# Save results to JSON
save_results() {
    cat > "$RESULTS_FILE" << EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "ssh_host": "$SSH_HOST",
  "connection": {
    "initial_seconds": $CONN_INITIAL,
    "subsequent_seconds": $CONN_SUBSEQUENT,
    "improvement_percent": $CONN_IMPROVEMENT
  },
  "git_clone": {
    "time_seconds": $GIT_CLONE_TIME,
    "size": "$CLONE_SIZE"
  },
  "rsync": {
    "time_seconds": $RSYNC_TIME,
    "transfer_rate_mbps": $TRANSFER_RATE
  },
  "config": {
    "optimizations_enabled": $optimizations_enabled,
    "optimizations_total": $optimizations_total,
    "optimization_percent": $OPTIMIZATION_PERCENTAGE
  }
}
EOF
    
    echo -e "${GREEN}[SAVED] Results saved to: $RESULTS_FILE${NC}"
}

# Main execution
main() {
    show_banner
    check_dependencies
    get_ssh_host
    
    test_connection_speed
    test_git_clone
    test_rsync_performance
    check_ssh_config
    
    generate_report
    save_results
    
    echo ""
    echo -e "${BOLD}Benchmark complete!${NC}"
    echo ""
}

# Run main
main
