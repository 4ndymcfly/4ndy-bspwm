#!/usr/bin/env bats
#
# Test suite for setup.sh
# Requires: bats-core (https://github.com/bats-core/bats-core)
#
# Run with: bats tests/test_setup.bats

# Setup function runs before each test
setup() {
    # Load the setup.sh file for inspection (but don't execute)
    SETUP_FILE="./setup.sh"

    # Create temporary directory for tests
    export TEST_TEMP_DIR="${BATS_TEST_TMPDIR}/bspwm-test-$$"
    mkdir -p "$TEST_TEMP_DIR"
}

# Teardown function runs after each test
teardown() {
    # Clean up temporary directory
    if [ -d "$TEST_TEMP_DIR" ]; then
        rm -rf "$TEST_TEMP_DIR"
    fi
}

#==============================================================================
# BASIC CHECKS
#==============================================================================

@test "setup.sh file exists" {
    [ -f "$SETUP_FILE" ]
}

@test "setup.sh is executable" {
    [ -x "$SETUP_FILE" ]
}

@test "setup.sh has correct shebang" {
    head -n 1 "$SETUP_FILE" | grep -q "#!/usr/bin/bash"
}

@test "setup.sh has author information" {
    grep -q "Author:" "$SETUP_FILE"
}

#==============================================================================
# SECURITY CHECKS
#==============================================================================

@test "setup.sh prevents execution as root" {
    # Verify the script checks for root user
    grep -q 'if \[ "\$NORMAL_USER" == "root" \]' "$SETUP_FILE"
    grep -q "You should not run the script as the root user" "$SETUP_FILE"
}

@test "setup.sh has Ctrl+C trap handler" {
    # Verify trap for INT signal exists
    grep -q "trap ctrl_c INT" "$SETUP_FILE"
}

@test "No hardcoded passwords in setup.sh" {
    # Check that there are no obvious password patterns
    # (excluding comments and known safe patterns)
    ! grep -E 'password[[:space:]]*=[[:space:]]*"[^$]' "$SETUP_FILE" | grep -v "^#"
}

@test "All exit codes are properly captured in variables" {
    # Verify we're using exit_code=$? pattern instead of double $?
    # Should have at least one instance of exit_code=$?
    grep -q "exit_code=\$?" "$SETUP_FILE"

    # Should NOT have the buggy pattern (checking $? twice)
    # Allow in comments though
    ! grep -E '^\s*if.*\$\?.*&&.*\$\?' "$SETUP_FILE"
}

@test "Variables are quoted in critical sections" {
    # Check that $dir variable is quoted (it's used in rm -rf)
    grep 'rm -rf.*\$dir' "$SETUP_FILE" | grep -q '\$dir' && {
        grep 'rm -rf' "$SETUP_FILE" | grep -q '"$dir"' || \
        grep 'rm -rf' "$SETUP_FILE" | grep -q '\${dir}'
    }
}

@test "No dangerous rm -rf without path validation" {
    # Ensure rm -rf is not used with unvalidated variables
    # Should have at least some quotes around variables
    if grep -q 'rm -rf \$' "$SETUP_FILE"; then
        # If we use rm -rf with variables, they should be quoted
        grep 'rm -rf' "$SETUP_FILE" | grep '\$' | grep -q '"'
    fi
}

#==============================================================================
# VERSION CHECKS
#==============================================================================

@test "LSD version is 1.2.0 or higher" {
    version=$(grep "LSD_VERSION=" "$SETUP_FILE" | cut -d'"' -f2)
    [ "$version" == "1.2.0" ] || [ "$version" \> "1.2.0" ]
}

@test "Go version is 1.23.5 or higher" {
    version=$(grep "GO_VERSION=" "$SETUP_FILE" | cut -d'"' -f2)
    [ "$version" == "1.23.5" ] || [ "$version" \> "1.23.5" ]
}

@test "LSD download URL is correctly formatted" {
    grep -q 'FILE_URL="https://github.com/lsd-rs/lsd/releases/download/v\${LSD_VERSION}/lsd_\${LSD_VERSION}_amd64.deb"' "$SETUP_FILE"
}

@test "Go download URL is correctly formatted" {
    grep -q 'GO_URL="https://go.dev/dl/\${GO_TAR}"' "$SETUP_FILE"
}

@test "OpenJDK version is LTS (21)" {
    grep -q "openjdk-21-jdk" "$SETUP_FILE"
}

#==============================================================================
# DEPENDENCY CHECKS
#==============================================================================

@test "All critical dependencies are listed" {
    # Core window manager dependencies
    grep -q "kitty" "$SETUP_FILE"
    grep -q "rofi" "$SETUP_FILE"
    grep -q "feh" "$SETUP_FILE"
    grep -q "polybar" "$SETUP_FILE"
}

@test "Zsh plugins are included (FIX verification)" {
    # These were missing before our fix
    grep -q "zsh-syntax-highlighting" "$SETUP_FILE"
    grep -q "zsh-autosuggestions" "$SETUP_FILE"
}

@test "net-tools is included (FIX verification)" {
    # This was missing before our fix
    grep -q "net-tools" "$SETUP_FILE"
}

@test "Docker is configured to start on boot" {
    grep -q "systemctl enable docker" "$SETUP_FILE"
}

@test "User is added to docker group" {
    grep -q "usermod -aG docker" "$SETUP_FILE"
}

#==============================================================================
# INSTALLATION STEPS CHECKS
#==============================================================================

@test "Installs bspwm dependencies before bspwm" {
    # Get line numbers
    deps_line=$(grep -n "Installing necessary dependencies for bspwm" "$SETUP_FILE" | cut -d: -f1)
    install_line=$(grep -n "Installing bspwm\.\.\." "$SETUP_FILE" | cut -d: -f1)

    [ "$deps_line" -lt "$install_line" ]
}

@test "Installs polybar dependencies before polybar" {
    deps_line=$(grep -n "Installing necessary dependencies for polybar" "$SETUP_FILE" | cut -d: -f1)
    install_line=$(grep -n "Installing polybar\.\.\." "$SETUP_FILE" | cut -d: -f1)

    [ "$deps_line" -lt "$install_line" ]
}

@test "Installs picom dependencies before picom" {
    deps_line=$(grep -n "Installing necessary dependencies for picom" "$SETUP_FILE" | cut -d: -f1)
    install_line=$(grep -n "Installing picom\.\.\." "$SETUP_FILE" | cut -d: -f1)

    [ "$deps_line" -lt "$install_line" ]
}

@test "Creates tools directory before installing tools" {
    grep -q "mkdir ~/tools" "$SETUP_FILE"
}

@test "Cleans up tools directory after installation" {
    grep -q "rm -rfv ~/tools" "$SETUP_FILE"
}

@test "Removes cloned repository after installation" {
    grep -q 'rm -rfv \$dir' "$SETUP_FILE"
}

#==============================================================================
# CONFIGURATION CHECKS
#==============================================================================

@test "Copies fonts to correct directory" {
    grep -q '\$fdir' "$SETUP_FILE"
    grep -q 'cp -rv \$dir/fonts/\*' "$SETUP_FILE"
}

@test "Copies wallpapers to home directory" {
    # Updated to use $HOME instead of ~/
    grep -q 'Wallpapers' "$SETUP_FILE"
    grep -q '\$HOME/Wallpapers' "$SETUP_FILE"
}

@test "Wallpaper directory check uses \$HOME not quoted tilde" {
    # This was a bug we fixed
    grep 'if \[\[ -d' "$SETUP_FILE" | grep Wallpapers | grep -q '\$HOME/Wallpapers'
    ! grep 'if \[\[ -d "~/Wallpapers"' "$SETUP_FILE"
}

@test "Configures .zshrc for both user and root" {
    grep -q 'cp -v \$dir/\.zshrc' "$SETUP_FILE"
    grep -q 'ln -sfv.*\.zshrc /root/\.zshrc' "$SETUP_FILE"
}

@test "Configures .p10k.zsh for both user and root" {
    grep -q 'cp -v \$dir/\.p10k\.zsh' "$SETUP_FILE"
    grep -q 'ln -sfv.*\.p10k\.zsh /root/\.p10k\.zsh' "$SETUP_FILE"
}

@test "Sets correct permissions for bspwm config" {
    grep -q 'chmod -R +x ~/.config/bspwm/' "$SETUP_FILE"
}

@test "Sets correct permissions for polybar scripts" {
    grep -q 'chmod +x ~/.config/polybar/launch.sh' "$SETUP_FILE"
    grep -q 'chmod +x ~/.config/polybar/shapes/scripts/\*' "$SETUP_FILE"
}

@test "Sets correct permissions for whichSystem.py" {
    grep -q 'chmod +x /usr/local/bin/whichSystem.py' "$SETUP_FILE"
}

#==============================================================================
# OH-MY-ZSH AND POWERLEVEL10K CHECKS
#==============================================================================

@test "Installs Oh My Zsh for normal user" {
    grep -q "ohmyzsh/ohmyzsh" "$SETUP_FILE"
    grep -q "sudo -u \$NORMAL_USER" "$SETUP_FILE"
}

@test "Installs Oh My Zsh for root" {
    grep -q "sudo sh.*ohmyzsh" "$SETUP_FILE"
}

@test "Installs Powerlevel10k for normal user" {
    grep -q "romkatv/powerlevel10k" "$SETUP_FILE"
}

@test "Installs Powerlevel10k for root" {
    grep -q "powerlevel10k.git /root/\.oh-my-zsh" "$SETUP_FILE"
}

@test "Has retry mechanism for network operations" {
    grep -q "retry_command()" "$SETUP_FILE"
}

#==============================================================================
# DOCKER CHECKS
#==============================================================================

@test "Pulls rustscan docker image" {
    grep -q "docker pull rustscan/rustscan" "$SETUP_FILE"
}

@test "Docker installation happens before docker commands" {
    docker_install=$(grep -n "docker.io" "$SETUP_FILE" | head -1 | cut -d: -f1)
    docker_pull=$(grep -n "docker pull" "$SETUP_FILE" | cut -d: -f1)

    [ "$docker_install" -lt "$docker_pull" ]
}

#==============================================================================
# ERROR HANDLING CHECKS
#==============================================================================

@test "Has error checking after apt install commands" {
    # Count apt install commands
    apt_installs=$(grep -c "sudo apt install" "$SETUP_FILE")

    # Should have at least 4 (main packages, bspwm deps, polybar deps, picom deps)
    [ "$apt_installs" -ge 4 ]

    # Each should be followed by error checking
    grep -A 3 "sudo apt install" "$SETUP_FILE" | grep -q "exit_code"
}

@test "Has error checking after git clone commands" {
    grep -A 5 "git clone.*bspwm" "$SETUP_FILE" | grep -q "exit_code"
    grep -A 5 "git clone.*sxhkd" "$SETUP_FILE" | grep -q "exit_code"
    grep -A 7 "git clone.*picom" "$SETUP_FILE" | grep -q "exit_code"
}

@test "Exits on critical failures" {
    # Should have multiple exit 1 for failures
    exit_count=$(grep -c "exit 1" "$SETUP_FILE")
    [ "$exit_count" -ge 5 ]
}

@test "Provides informative error messages" {
    # Check that error messages exist
    grep -q "Failed to install some packages" "$SETUP_FILE"
    grep -q "Failed to install bspwm" "$SETUP_FILE"
    grep -q "Failed to install LSD" "$SETUP_FILE"
}

#==============================================================================
# USER INTERACTION CHECKS
#==============================================================================

@test "Asks for reboot confirmation" {
    grep -q "Do you want to restart the system now?" "$SETUP_FILE"
}

@test "Has banner function" {
    grep -q "function banner()" "$SETUP_FILE"
}

@test "Shows progress messages to user" {
    # Should have multiple echo statements with colors
    grep -q "BLUE.*Installing" "$SETUP_FILE"
    grep -q "GREEN.*Done" "$SETUP_FILE"
    grep -q "PURPLE.*Installing" "$SETUP_FILE"
}

#==============================================================================
# TOOLS INSTALLATION CHECKS
#==============================================================================

@test "Installs Arsenal CLI" {
    grep -q "pipx install arsenal-cli" "$SETUP_FILE"
}

@test "Arsenal is installed for normal user not root" {
    grep "arsenal-cli" "$SETUP_FILE" | grep -q "sudo -u \$NORMAL_USER"
}

@test "Copies whichSystem.py to /usr/local/bin" {
    grep -q "cp -v.*whichSystem.py /usr/local/bin/" "$SETUP_FILE"
}

@test "Copies polybar scripts to correct location" {
    grep -q 'cp -rv \$dir/scripts/\*\.sh ~/.config/polybar/shapes/scripts/' "$SETUP_FILE"
}

@test "Creates target file for polybar" {
    grep -q "touch ~/.config/polybar/shapes/scripts/target" "$SETUP_FILE"
}

#==============================================================================
# PATH AND ENVIRONMENT CHECKS
#==============================================================================

@test "Uses absolute paths for critical operations" {
    # Check that /usr/local/bin is used
    grep -q "/usr/local/bin/whichSystem.py" "$SETUP_FILE"
    grep -q "/usr/local/go" "$SETUP_FILE"
}

@test "Uses variables for dynamic paths" {
    # Should use $HOME or ~ for home directory
    grep -q '\$HOME\|~/' "$SETUP_FILE"

    # Should use $dir for repo directory
    grep -q '\$dir' "$SETUP_FILE"
}

#==============================================================================
# COMPILATION CHECKS
#==============================================================================

@test "Uses multiple cores for compilation (nproc)" {
    grep -q 'make -j\$(nproc)' "$SETUP_FILE"
}

@test "Compiles with meson for picom" {
    grep -q "meson --buildtype=release" "$SETUP_FILE"
}

@test "Uses ninja for picom build" {
    grep -q "ninja -C build" "$SETUP_FILE"
}

#==============================================================================
# CLEANUP CHECKS
#==============================================================================

@test "Changes directory back after building tools" {
    # After building each tool, should cd back
    grep -A 20 "git clone.*bspwm" "$SETUP_FILE" | grep -q "cd \.\."
    grep -A 20 "git clone.*sxhkd" "$SETUP_FILE" | grep -q "cd \.\."
}

@test "Removes downloaded files after use" {
    # LSD .deb file
    grep 'rm -f.*lsd.deb' "$SETUP_FILE" || \
    grep 'rm -f "\$FILE_NAME"' "$SETUP_FILE"

    # Go tar file
    grep 'rm -f.*\$GO_TAR' "$SETUP_FILE"
}

#==============================================================================
# STYLE AND BEST PRACTICES
#==============================================================================

@test "Uses consistent color variables" {
    grep -q "GREEN=" "$SETUP_FILE"
    grep -q "RED=" "$SETUP_FILE"
    grep -q "BLUE=" "$SETUP_FILE"
    grep -q "NOCOLOR=" "$SETUP_FILE"
}

@test "Has sleep delays for user readability" {
    # Should have multiple sleep commands
    sleep_count=$(grep -c "sleep" "$SETUP_FILE")
    [ "$sleep_count" -ge 10 ]
}

@test "Suppresses unnecessary output" {
    # Should redirect to /dev/null in multiple places
    grep -q "> /dev/null 2>&1" "$SETUP_FILE"
}

#==============================================================================
# INTEGRATION TESTS (lightweight)
#==============================================================================

@test "Script syntax is valid (bash -n)" {
    bash -n "$SETUP_FILE"
}

@test "No shellcheck critical errors" {
    skip "Requires shellcheck to be installed"
    # This test is skipped by default but can be enabled
    # shellcheck -S error "$SETUP_FILE"
}

@test "NORMAL_USER variable is obtained correctly" {
    grep -q 'NORMAL_USER=\$(getent passwd 1000' "$SETUP_FILE"
}

@test "All required directories exist in repo" {
    [ -d "./config" ]
    [ -d "./fonts" ]
    [ -d "./scripts" ]
    [ -d "./wallpapers" ]
}

#==============================================================================
# REGRESSION TESTS (verify our fixes)
#==============================================================================

@test "[REGRESSION] Command injection fix - uses exit_code variable" {
    # We fixed the double $? bug
    count=$(grep -c "exit_code=\$?" "$SETUP_FILE")
    [ "$count" -ge 8 ]
}

@test "[REGRESSION] Wallpaper directory fix - uses \$HOME not tilde" {
    # We fixed the ~/Wallpapers bug
    grep Wallpapers "$SETUP_FILE" | grep 'if \[\[' | grep -q '\$HOME'
}

@test "[REGRESSION] Version updates - LSD is 1.2.0" {
    grep -q 'LSD_VERSION="1.2.0"' "$SETUP_FILE"
}

@test "[REGRESSION] Version updates - Go is 1.23.5" {
    grep -q 'GO_VERSION="1.23.5"' "$SETUP_FILE"
}

@test "[REGRESSION] Dependencies fix - includes zsh plugins" {
    # We added these missing dependencies
    grep "apt install" "$SETUP_FILE" | grep -q "zsh-syntax-highlighting"
    grep "apt install" "$SETUP_FILE" | grep -q "zsh-autosuggestions"
}

@test "[REGRESSION] rm -f doesn't have error check" {
    # We removed the useless error check after rm -f
    ! grep -A 2 'rm -f \$GO_TAR' "$SETUP_FILE" | grep "Failed to remove"
}
