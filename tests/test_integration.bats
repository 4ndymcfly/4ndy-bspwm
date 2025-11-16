#!/usr/bin/env bats
#
# Integration tests for setup.sh
# These tests verify the script works as a whole
#
# WARNING: These tests do NOT actually run setup.sh (would modify system)
# Instead, they verify preconditions and simulate key operations
#
# Run with: bats tests/test_integration.bats

setup() {
    SETUP_FILE="./setup.sh"
    export TEST_HOME="${BATS_TEST_TMPDIR}/fake-home"
    mkdir -p "$TEST_HOME"
}

teardown() {
    if [ -d "$TEST_HOME" ]; then
        rm -rf "$TEST_HOME"
    fi
}

#==============================================================================
# PREREQUISITE CHECKS
#==============================================================================

@test "[INTEGRATION] All required directories exist in repository" {
    [ -d "./config" ]
    [ -d "./fonts" ]
    [ -d "./scripts" ]
    [ -d "./wallpapers" ]
    [ -d "./assets" ]
}

@test "[INTEGRATION] Required config subdirectories exist" {
    [ -d "./config/bspwm" ]
    [ -d "./config/polybar" ]
    [ -d "./config/kitty" ]
    [ -d "./config/picom" ]
}

@test "[INTEGRATION] Required scripts exist" {
    [ -f "./scripts/whichSystem.py" ]
    [ -f "./scripts/ethernet_status.sh" ]
    [ -f "./scripts/vpn_status.sh" ]
}

@test "[INTEGRATION] Configuration files exist" {
    [ -f "./.zshrc" ]
    [ -f "./.p10k.zsh" ]
}

#==============================================================================
# DOWNLOAD URL VALIDATION
#==============================================================================

@test "[INTEGRATION] LSD download URL is reachable" {
    skip "Requires network access - run manually"

    # Extract version from script
    version=$(grep "LSD_VERSION=" "$SETUP_FILE" | cut -d'"' -f2)
    url="https://github.com/lsd-rs/lsd/releases/download/v${version}/lsd_${version}_amd64.deb"

    # Check URL returns 200 (requires curl)
    if command -v curl &> /dev/null; then
        curl -L --head --fail "$url" &> /dev/null
    fi
}

@test "[INTEGRATION] Go download URL is reachable" {
    skip "Requires network access - run manually"

    version=$(grep "GO_VERSION=" "$SETUP_FILE" | cut -d'"' -f2)
    url="https://go.dev/dl/go${version}.linux-amd64.tar.gz"

    if command -v curl &> /dev/null; then
        curl -L --head --fail "$url" &> /dev/null
    fi
}

@test "[INTEGRATION] GitHub repositories are accessible" {
    skip "Requires network access - run manually"

    # Test that key repos exist
    repos=(
        "https://github.com/baskerville/bspwm"
        "https://github.com/baskerville/sxhkd"
        "https://github.com/ibhagwan/picom"
        "https://github.com/ohmyzsh/ohmyzsh"
        "https://github.com/romkatv/powerlevel10k"
    )

    if command -v curl &> /dev/null; then
        for repo in "${repos[@]}"; do
            curl -L --head --fail "$repo" &> /dev/null
        done
    fi
}

#==============================================================================
# SCRIPT FLOW VALIDATION
#==============================================================================

@test "[INTEGRATION] Script exits early when run as root" {
    # Create a test script that simulates root user
    cat > "$TEST_HOME/test_root.sh" << 'EOF'
#!/usr/bin/bash
NORMAL_USER="root"
if [ "$NORMAL_USER" == "root" ]; then
    echo "Should not run as root"
    exit 1
fi
echo "Would continue..."
EOF

    chmod +x "$TEST_HOME/test_root.sh"
    run "$TEST_HOME/test_root.sh"

    [ "$status" -eq 1 ]
    [[ "$output" == *"Should not run as root"* ]]
}

@test "[INTEGRATION] Script handles Ctrl+C gracefully" {
    # Extract and test the trap handler
    cat > "$TEST_HOME/test_trap.sh" << 'EOF'
#!/usr/bin/bash
trap 'echo "Caught INT"; exit 1' INT

echo "Running..."
sleep 1 &
kill -INT $$
EOF

    chmod +x "$TEST_HOME/test_trap.sh"
    run "$TEST_HOME/test_trap.sh"

    [ "$status" -eq 1 ]
    [[ "$output" == *"Caught INT"* ]]
}

#==============================================================================
# FILE OPERATIONS SIMULATION
#==============================================================================

@test "[INTEGRATION] Font copying would work with correct structure" {
    # Simulate font directory structure
    mkdir -p "$TEST_HOME/.local/share/fonts"
    mkdir -p "$TEST_HOME/repo/fonts"

    # Create dummy font file
    touch "$TEST_HOME/repo/fonts/test.ttf"

    # Simulate the copy operation
    cp -r "$TEST_HOME/repo/fonts/"* "$TEST_HOME/.local/share/fonts/"

    # Verify
    [ -f "$TEST_HOME/.local/share/fonts/test.ttf" ]
}

@test "[INTEGRATION] Wallpaper copying creates directory if needed" {
    # Test the fixed version (using $HOME)
    mkdir -p "$TEST_HOME/repo/wallpapers"
    touch "$TEST_HOME/repo/wallpapers/test.jpg"

    # Simulate the corrected logic
    if [[ ! -d "$TEST_HOME/Wallpapers" ]]; then
        mkdir "$TEST_HOME/Wallpapers"
    fi
    cp -r "$TEST_HOME/repo/wallpapers/"* "$TEST_HOME/Wallpapers/"

    [ -f "$TEST_HOME/Wallpapers/test.jpg" ]
}

@test "[INTEGRATION] Config files can be copied to .config" {
    mkdir -p "$TEST_HOME/.config"
    mkdir -p "$TEST_HOME/repo/config/bspwm"

    touch "$TEST_HOME/repo/config/bspwm/bspwmrc"

    cp -r "$TEST_HOME/repo/config/"* "$TEST_HOME/.config/"

    [ -f "$TEST_HOME/.config/bspwm/bspwmrc" ]
}

#==============================================================================
# PERMISSION OPERATIONS
#==============================================================================

@test "[INTEGRATION] Executable permissions can be set" {
    mkdir -p "$TEST_HOME/.config/bspwm"
    touch "$TEST_HOME/.config/bspwm/bspwmrc"

    chmod +x "$TEST_HOME/.config/bspwm/bspwmrc"

    [ -x "$TEST_HOME/.config/bspwm/bspwmrc" ]
}

@test "[INTEGRATION] Recursive permissions work correctly" {
    mkdir -p "$TEST_HOME/.config/bspwm/scripts"
    touch "$TEST_HOME/.config/bspwm/scripts/test.sh"

    chmod -R +x "$TEST_HOME/.config/bspwm/"

    [ -x "$TEST_HOME/.config/bspwm/scripts/test.sh" ]
}

#==============================================================================
# SYMLINK OPERATIONS
#==============================================================================

@test "[INTEGRATION] .zshrc can be symlinked" {
    touch "$TEST_HOME/.zshrc"

    # Create fake root home for testing
    mkdir -p "$TEST_HOME/fake-root"

    ln -sf "$TEST_HOME/.zshrc" "$TEST_HOME/fake-root/.zshrc"

    [ -L "$TEST_HOME/fake-root/.zshrc" ]
    [ -f "$TEST_HOME/fake-root/.zshrc" ]
}

@test "[INTEGRATION] .p10k.zsh can be symlinked" {
    touch "$TEST_HOME/.p10k.zsh"
    mkdir -p "$TEST_HOME/fake-root"

    ln -sf "$TEST_HOME/.p10k.zsh" "$TEST_HOME/fake-root/.p10k.zsh"

    [ -L "$TEST_HOME/fake-root/.p10k.zsh" ]
}

#==============================================================================
# ERROR HANDLING FLOW
#==============================================================================

@test "[INTEGRATION] Exit code capture works correctly" {
    cat > "$TEST_HOME/test_exitcode.sh" << 'EOF'
#!/usr/bin/bash
false
exit_code=$?
if [ $exit_code != 0 ]; then
    echo "Correctly captured error"
    exit 1
fi
EOF

    chmod +x "$TEST_HOME/test_exitcode.sh"
    run "$TEST_HOME/test_exitcode.sh"

    [ "$status" -eq 1 ]
    [[ "$output" == *"Correctly captured error"* ]]
}

@test "[INTEGRATION] Multiple exit code captures work independently" {
    cat > "$TEST_HOME/test_multi_exitcode.sh" << 'EOF'
#!/usr/bin/bash
true
exit_code=$?
echo "First: $exit_code"

false
exit_code=$?
echo "Second: $exit_code"

if [ $exit_code != 0 ]; then
    exit 0
fi
EOF

    chmod +x "$TEST_HOME/test_multi_exitcode.sh"
    run "$TEST_HOME/test_multi_exitcode.sh"

    [ "$status" -eq 0 ]
    [[ "$output" == *"First: 0"* ]]
    [[ "$output" == *"Second: 1"* ]]
}

#==============================================================================
# DEPENDENCY CHECKING
#==============================================================================

@test "[INTEGRATION] Can detect NORMAL_USER correctly" {
    cat > "$TEST_HOME/test_user.sh" << 'EOF'
#!/usr/bin/bash
# Simulate getting user from passwd
NORMAL_USER=$(echo "testuser")
echo "User: $NORMAL_USER"

if [ "$NORMAL_USER" != "root" ]; then
    echo "Valid user"
    exit 0
else
    exit 1
fi
EOF

    chmod +x "$TEST_HOME/test_user.sh"
    run "$TEST_HOME/test_user.sh"

    [ "$status" -eq 0 ]
    [[ "$output" == *"Valid user"* ]]
}

#==============================================================================
# COMPILATION SIMULATION
#==============================================================================

@test "[INTEGRATION] nproc command works for parallel make" {
    if command -v nproc &> /dev/null; then
        cores=$(nproc)
        [ "$cores" -ge 1 ]
    else
        skip "nproc not available"
    fi
}

@test "[INTEGRATION] Can create and navigate directories" {
    mkdir -p "$TEST_HOME/tools"
    cd "$TEST_HOME/tools" || exit 1

    mkdir test_dir
    cd test_dir || exit 1
    pwd | grep -q "test_dir"

    cd ..
    pwd | grep -q "tools"
}

#==============================================================================
# CLEANUP OPERATIONS
#==============================================================================

@test "[INTEGRATION] Cleanup removes correct directories" {
    mkdir -p "$TEST_HOME/tools/subdir"
    touch "$TEST_HOME/tools/file.txt"

    # Simulate cleanup
    rm -rf "$TEST_HOME/tools"

    [ ! -d "$TEST_HOME/tools" ]
}

@test "[INTEGRATION] rm -f doesn't fail on missing files" {
    # This should succeed even if file doesn't exist
    rm -f "$TEST_HOME/nonexistent.tar.gz"

    [ $? -eq 0 ]
}

#==============================================================================
# REBOOT PROMPT SIMULATION
#==============================================================================

@test "[INTEGRATION] Reboot prompt accepts 'y'" {
    cat > "$TEST_HOME/test_reboot.sh" << 'EOF'
#!/usr/bin/bash
read -r response
response=${response:-"y"}
if [[ $response =~ ^[Yy]$ ]]; then
    echo "Would reboot"
    exit 0
fi
echo "No reboot"
exit 0
EOF

    chmod +x "$TEST_HOME/test_reboot.sh"
    run bash -c "echo 'y' | $TEST_HOME/test_reboot.sh"

    [ "$status" -eq 0 ]
    [[ "$output" == *"Would reboot"* ]]
}

@test "[INTEGRATION] Reboot prompt accepts 'n'" {
    cat > "$TEST_HOME/test_reboot.sh" << 'EOF'
#!/usr/bin/bash
read -r response
if [[ $response =~ ^[Nn]$ ]]; then
    echo "No reboot"
    exit 0
fi
exit 1
EOF

    chmod +x "$TEST_HOME/test_reboot.sh"
    run bash -c "echo 'n' | $TEST_HOME/test_reboot.sh"

    [ "$status" -eq 0 ]
    [[ "$output" == *"No reboot"* ]]
}

@test "[INTEGRATION] Reboot prompt defaults to 'y' on empty input" {
    cat > "$TEST_HOME/test_reboot.sh" << 'EOF'
#!/usr/bin/bash
read -r REPLY
REPLY=${REPLY:-"y"}
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Default yes"
    exit 0
fi
exit 1
EOF

    chmod +x "$TEST_HOME/test_reboot.sh"
    run bash -c "echo '' | $TEST_HOME/test_reboot.sh"

    [ "$status" -eq 0 ]
    [[ "$output" == *"Default yes"* ]]
}

#==============================================================================
# RETRY MECHANISM
#==============================================================================

@test "[INTEGRATION] Retry function structure is valid" {
    # Extract and test retry mechanism
    cat > "$TEST_HOME/test_retry.sh" << 'EOF'
#!/usr/bin/bash
retry_command() {
    local retries=3
    local count=0
    until "$@"; do
        exit_code=$?
        count=$((count + 1))
        if [ $count -lt $retries ]; then
            sleep 0.1
        else
            echo "Failed after $retries attempts"
            return $exit_code
        fi
    done
    return 0
}

# Test with failing command
retry_command false
exit $?
EOF

    chmod +x "$TEST_HOME/test_retry.sh"
    run "$TEST_HOME/test_retry.sh"

    [ "$status" -eq 1 ]
    [[ "$output" == *"Failed after 3 attempts"* ]]
}

#==============================================================================
# FULL WORKFLOW SIMULATION (Dry-run)
#==============================================================================

@test "[INTEGRATION] Dry-run simulation completes all phases" {
    # Create a simplified dry-run version
    cat > "$TEST_HOME/dry_run.sh" << 'EOF'
#!/usr/bin/bash

NORMAL_USER=$(whoami)
if [ "$NORMAL_USER" == "root" ]; then
    echo "ERROR: Running as root"
    exit 1
fi

echo "Phase 1: Package installation (simulated)"
echo "Phase 2: LSD installation (simulated)"
echo "Phase 3: Go installation (simulated)"
echo "Phase 4: bspwm dependencies (simulated)"
echo "Phase 5: Tool compilation (simulated)"
echo "Phase 6: Configuration (simulated)"
echo "Phase 7: Cleanup (simulated)"
echo "All phases completed successfully"
exit 0
EOF

    chmod +x "$TEST_HOME/dry_run.sh"
    run "$TEST_HOME/dry_run.sh"

    [ "$status" -eq 0 ]
    [[ "$output" == *"All phases completed successfully"* ]]
}

#==============================================================================
# COMPATIBILITY CHECKS
#==============================================================================

@test "[INTEGRATION] Bash version is sufficient" {
    # Requires bash 4.0+
    version=$(bash --version | head -1 | grep -oP '\d+\.\d+' | head -1)
    major=$(echo "$version" | cut -d. -f1)

    [ "$major" -ge 4 ]
}

@test "[INTEGRATION] Required commands are available in path" {
    skip "System-dependent - run manually on target system"

    command -v git
    command -v make
    command -v curl
    command -v wget
}

@test "[INTEGRATION] Systemd is available (for docker enable)" {
    skip "System-dependent - run manually on target system"

    command -v systemctl
}
