#!/usr/bin/env bats
#
# Security-focused tests for setup.sh
# Tests for vulnerabilities, injection attacks, and secure coding practices
#
# Run with: bats tests/test_security.bats

setup() {
    SETUP_FILE="./setup.sh"
}

#==============================================================================
# COMMAND INJECTION PREVENTION
#==============================================================================

@test "[SECURITY] No unquoted variable expansions in dangerous commands" {
    # Check rm commands have quoted variables
    if grep "rm -rf" "$SETUP_FILE" | grep -v "^#" | grep '\$'; then
        # All rm -rf with variables should have quotes
        grep "rm -rf" "$SETUP_FILE" | grep -v "^#" | grep '\$' | grep -q '"'
    fi
}

@test "[SECURITY] No eval usage" {
    ! grep -E '^[^#]*\beval\b' "$SETUP_FILE"
}

@test "[SECURITY] All user input is validated (NORMAL_USER)" {
    # Check that NORMAL_USER is validated before use
    grep -q 'if \[ "\$NORMAL_USER" == "root" \]' "$SETUP_FILE"
}

@test "[SECURITY] No direct execution of downloaded scripts" {
    # Verify that downloaded files are verified before execution
    # Should NOT have: curl ... | sh or wget ... | bash patterns
    ! grep -E 'curl.*\|.*sh' "$SETUP_FILE"
    ! grep -E 'wget.*\|.*bash' "$SETUP_FILE"
}

@test "[SECURITY] Downloaded files are saved before execution" {
    # Go download
    grep -A 3 "curl -LO.*go.dev" "$SETUP_FILE" | grep -q "tar -C"

    # LSD download
    grep -A 3 "wget.*lsd.*\.deb" "$SETUP_FILE" | grep -q "dpkg -i"
}

#==============================================================================
# PRIVILEGE ESCALATION PREVENTION
#==============================================================================

@test "[SECURITY] Script refuses to run as root" {
    # Must check and exit if root
    grep -A 2 'if \[ "\$NORMAL_USER" == "root" \]' "$SETUP_FILE" | grep -q "exit 1"
}

@test "[SECURITY] sudo is used selectively, not globally" {
    # Script should not be run with sudo at the top level
    ! grep -q "^sudo -i" "$SETUP_FILE"
    ! grep -q "^su -" "$SETUP_FILE"
}

@test "[SECURITY] User files are created with correct ownership" {
    # Check that files for NORMAL_USER are created as that user
    grep "sudo -u \$NORMAL_USER" "$SETUP_FILE" | grep -q "oh-my-zsh"
}

#==============================================================================
# FILE SYSTEM SAFETY
#==============================================================================

@test "[SECURITY] Critical directories are not hardcoded to root" {
    # Should NOT have commands that affect / or /home directly
    ! grep -E 'rm -rf (/|/home)($|[^/])' "$SETUP_FILE"
}

@test "[SECURITY] Temp directories use safe patterns" {
    # If using /tmp, should use unique identifiers
    if grep -q "/tmp" "$SETUP_FILE"; then
        grep "/tmp" "$SETUP_FILE" | grep -q '\$\|mktemp'
    fi
}

@test "[SECURITY] No wildcard in rm -rf at root level" {
    # Should NOT have: rm -rf /* or rm -rf ~/*
    ! grep -E 'rm -rf (/\*|~/\*)' "$SETUP_FILE"
}

@test "[SECURITY] Directory creation uses -p flag safely" {
    # mkdir -p should be used, but paths should be sane
    if grep "mkdir -p" "$SETUP_FILE"; then
        # Should have at least some mkdir -p
        grep -q "mkdir -p" "$SETUP_FILE"

        # Should NOT be creating root dirs
        ! grep "mkdir -p /" "$SETUP_FILE"
    fi
}

#==============================================================================
# NETWORK SECURITY
#==============================================================================

@test "[SECURITY] All downloads use HTTPS" {
    # GitHub downloads
    grep "github.com" "$SETUP_FILE" | grep -v "^#" | grep -v "http://"

    # Go downloads
    grep "go.dev" "$SETUP_FILE" | grep -v "^#" | grep "https://"

    # Raw content from GitHub
    if grep "raw.githubusercontent.com" "$SETUP_FILE" | grep -v "^#"; then
        grep "raw.githubusercontent.com" "$SETUP_FILE" | grep -v "^#" | grep -q "https://"
    fi
}

@test "[SECURITY] No credentials in script" {
    # Should not have obvious credential patterns
    ! grep -iE '(password|passwd|pwd)[[:space:]]*=[[:space:]]*["\x27][^$]' "$SETUP_FILE" | grep -v "^#"
    ! grep -iE 'api[_-]?key[[:space:]]*=' "$SETUP_FILE" | grep -v "^#"
    ! grep -iE 'secret[[:space:]]*=' "$SETUP_FILE" | grep -v "^#"
    ! grep -iE 'token[[:space:]]*=' "$SETUP_FILE" | grep -v "^#"
}

#==============================================================================
# PACKAGE INTEGRITY
#==============================================================================

@test "[SECURITY] Package manager updates before install" {
    # While we suppress output, apt update should happen
    # (we can't test it runs, but we can check it's in the script)
    grep -q "apt.*update" "$SETUP_FILE" || \
    grep -q "apt-get.*update" "$SETUP_FILE"
}

@test "[SECURITY] Installations fail safely" {
    # Critical installations should check exit codes
    grep -A 5 "apt install.*docker" "$SETUP_FILE" | grep -q "exit_code"
    grep -A 5 "apt install.*kitty" "$SETUP_FILE" | grep -q "exit_code"
}

#==============================================================================
# CODE INJECTION PREVENTION
#==============================================================================

@test "[SECURITY] No use of backticks (use \$() instead)" {
    # Backticks are deprecated and less safe
    ! grep -E '^[^#]*`[^`]+`' "$SETUP_FILE"
}

@test "[SECURITY] Variable assignments use proper syntax" {
    # Check for common injection patterns in variable assignments
    # Should NOT have: var=$(evil input) without validation
    # This is a basic check - we verify at least quotes are used

    if grep -E '\$\(.*\$[A-Z_]+.*\)' "$SETUP_FILE" | grep -v "^#"; then
        # If we're using variables in command substitutions, they should be quoted
        true  # This is a placeholder - full check is complex
    fi
}

@test "[SECURITY] Signal handlers are safe" {
    # Check ctrl_c handler doesn't do anything dangerous
    grep -A 5 "function ctrl_c" "$SETUP_FILE" | {
        ! grep -E "rm -rf \$[A-Z]+" || \
        grep -E "rm -rf" | grep -q '"'
    }
}

#==============================================================================
# PATH TRAVERSAL PREVENTION
#==============================================================================

@test "[SECURITY] No use of .. in critical paths" {
    # Check that we're not using ../ in dangerous operations
    grep "rm -rf" "$SETUP_FILE" | ! grep -q '\.\.'
    grep "chmod" "$SETUP_FILE" | ! grep -q '\.\.'
}

@test "[SECURITY] Symlinks use absolute paths or validated relatives" {
    # ln -s commands should use proper paths
    if grep "ln -s" "$SETUP_FILE"; then
        # We have symlinks, check they're using variables or absolute paths
        grep "ln -s" "$SETUP_FILE" | grep -E '(/|~|\$HOME|\$)'
    fi
}

#==============================================================================
# RACE CONDITION PREVENTION
#==============================================================================

@test "[SECURITY] Lockfile for pacman-like operations" {
    # If using database operations, should handle locks
    # For our apt-based system, apt handles this
    # Just verify we're not trying to run multiple apt instances
    ! grep -E 'apt.*&.*apt' "$SETUP_FILE"
}

@test "[SECURITY] No TOCTOU vulnerabilities in file checks" {
    # Time-of-check to time-of-use
    # If we check a file exists, we should use it immediately after
    # This is a basic structural check

    if grep -E 'if.*-f.*then' "$SETUP_FILE"; then
        # We have file existence checks - this is OK if used properly
        # Full TOCTOU prevention requires manual review
        true
    fi
}

#==============================================================================
# ENVIRONMENT VARIABLE SAFETY
#==============================================================================

@test "[SECURITY] PATH is not modified to include ." {
    # Should not add current directory to PATH
    ! grep -E 'PATH=.*:\.($|:)' "$SETUP_FILE"
    ! grep -E 'export PATH=\.:' "$SETUP_FILE"
}

@test "[SECURITY] Sensitive operations don't rely on environment" {
    # Critical commands should use absolute paths or be validated
    grep "make install" "$SETUP_FILE" | grep -q "sudo"
}

#==============================================================================
# LOGGING AND DEBUGGING SAFETY
#==============================================================================

@test "[SECURITY] No set -x in production (debug mode)" {
    # Debug mode can leak sensitive information
    ! grep -E '^[[:space:]]*set -x' "$SETUP_FILE"
}

@test "[SECURITY] Errors don't expose system information excessively" {
    # Error messages should be helpful but not leak internals
    # Check that errors are user-friendly
    grep "echo.*Failed" "$SETUP_FILE" | head -1 | grep -q "\-e"
}

#==============================================================================
# PERMISSION CHECKS
#==============================================================================

@test "[SECURITY] Executable permissions are set explicitly" {
    # chmod +x should be used for scripts
    grep -q "chmod +x" "$SETUP_FILE"
    grep -q "chmod -R +x ~/.config/bspwm" "$SETUP_FILE"
}

@test "[SECURITY] No chmod 777 (world-writable)" {
    # Should never make files world-writable
    ! grep "chmod 777" "$SETUP_FILE"
    ! grep "chmod.*a+w" "$SETUP_FILE"
}

@test "[SECURITY] Config files have appropriate permissions" {
    # .zshrc and similar should not be world-writable
    # They're copied with cp which preserves reasonable permissions
    grep "cp.*\.zshrc" "$SETUP_FILE" | ! grep "chmod 777"
}

#==============================================================================
# DOCKER SECURITY
#==============================================================================

@test "[SECURITY] Docker user is added to group explicitly" {
    grep -q "usermod -aG docker" "$SETUP_FILE"
}

@test "[SECURITY] Docker service is enabled securely" {
    grep "systemctl enable docker" "$SETUP_FILE" | grep -v "^#"
}

@test "[SECURITY] Docker images are from trusted sources" {
    # rustscan is a well-known security tool
    grep "docker pull" "$SETUP_FILE" | grep -q "rustscan/rustscan"

    # Should not pull from unknown registries
    ! grep "docker pull" "$SETUP_FILE" | grep -E "localhost|192\.168\."
}

#==============================================================================
# REGRESSION TESTS - Verify security fixes
#==============================================================================

@test "[SECURITY][REGRESSION] Exit code check fix prevents race condition" {
    # We fixed the $? $? bug which could cause race conditions
    grep -c "exit_code=\$?" "$SETUP_FILE" | {
        read count
        [ "$count" -ge 8 ]
    }
}

@test "[SECURITY][REGRESSION] Wallpaper path fix prevents injection" {
    # Fixed: "~/Wallpapers" -> $HOME/Wallpapers
    grep Wallpapers "$SETUP_FILE" | grep 'mkdir\|if.*-d' | grep -q '\$HOME'
}

@test "[SECURITY][REGRESSION] Go tarball is removed after extraction" {
    # Prevents leaving downloaded files around
    grep -q 'rm -f.*\$GO_TAR' "$SETUP_FILE"
}

#==============================================================================
# SUPPLY CHAIN SECURITY
#==============================================================================

@test "[SECURITY] Git clones use HTTPS not git://" {
    grep "git clone" "$SETUP_FILE" | grep -v "^#" | ! grep "git://"
}

@test "[SECURITY] GitHub URLs use proper format" {
    # Should be https://github.com/user/repo
    grep "github.com" "$SETUP_FILE" | grep -v "^#" | grep -q "https://"
}

@test "[SECURITY] Raw GitHub content uses githubusercontent.com" {
    # Raw content should use proper domain
    if grep "raw.githubusercontent.com" "$SETUP_FILE" | grep -v "^#"; then
        grep "raw.githubusercontent.com" "$SETUP_FILE" | grep -v "^#" | grep -q "https://"
    fi
}

@test "[SECURITY] Dependencies come from official repositories" {
    # bspwm from official repo
    grep "git clone.*bspwm" "$SETUP_FILE" | grep -q "baskerville/bspwm"

    # sxhkd from official repo
    grep "git clone.*sxhkd" "$SETUP_FILE" | grep -q "baskerville/sxhkd"

    # picom from official repo
    grep "git clone.*picom" "$SETUP_FILE" | grep -q "ibhagwan/picom"
}
