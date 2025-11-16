#!/usr/bin/bash
#
# Test Runner Script for 4ndy-bspwm
# Convenience script to run all tests with proper formatting
#

# Colors
GREEN="\e[0;32m\033[1m"
RED="\e[0;31m\033[1m"
BLUE="\e[0;34m\033[1m"
YELLOW="\e[0;33m\033[1m"
NOCOLOR="\033[0m\e[0m"

# Check if bats is installed
if ! command -v bats &> /dev/null; then
    echo -e "${RED}[!] Bats is not installed!${NOCOLOR}"
    echo -e "${YELLOW}[*] Install with: sudo apt install bats${NOCOLOR}"
    exit 1
fi

# Parse command line arguments
VERBOSE=false
FILTER=""
SUITE="all"

while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -f|--filter)
            FILTER="$2"
            shift 2
            ;;
        -s|--suite)
            SUITE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -v, --verbose     Show verbose output"
            echo "  -f, --filter STR  Run only tests matching STR"
            echo "  -s, --suite NAME  Run specific suite (unit|security|integration|all)"
            echo "  -h, --help        Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                          # Run all tests"
            echo "  $0 -v                       # Run all tests with verbose output"
            echo "  $0 -s security              # Run only security tests"
            echo "  $0 -f 'LSD version'         # Run tests matching 'LSD version'"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NOCOLOR}"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Change to repository root
cd "$(dirname "$0")/.." || exit 1

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NOCOLOR}"
echo -e "${BLUE}║        4ndy-bspwm Test Suite Runner                     ║${NOCOLOR}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NOCOLOR}"
echo ""

# Build bats command
BATS_CMD="bats"
if [ "$VERBOSE" = true ]; then
    BATS_CMD="$BATS_CMD --verbose"
fi

if [ -n "$FILTER" ]; then
    BATS_CMD="$BATS_CMD --filter '$FILTER'"
fi

BATS_CMD="$BATS_CMD --pretty --timing"

# Track results
FAILED=0

# Function to run test suite
run_suite() {
    local suite_name="$1"
    local suite_file="$2"

    echo -e "${YELLOW}[*] Running $suite_name...${NOCOLOR}"
    echo ""

    if eval "$BATS_CMD tests/$suite_file"; then
        echo ""
        echo -e "${GREEN}[✓] $suite_name passed${NOCOLOR}"
        echo ""
    else
        echo ""
        echo -e "${RED}[✗] $suite_name failed${NOCOLOR}"
        echo ""
        FAILED=$((FAILED + 1))
    fi
}

# Run tests based on suite selection
case "$SUITE" in
    unit)
        run_suite "Unit Tests" "test_setup.bats"
        ;;
    security)
        run_suite "Security Tests" "test_security.bats"
        ;;
    integration)
        run_suite "Integration Tests" "test_integration.bats"
        ;;
    all)
        run_suite "Unit Tests" "test_setup.bats"
        run_suite "Security Tests" "test_security.bats"
        run_suite "Integration Tests" "test_integration.bats"
        ;;
    *)
        echo -e "${RED}[!] Unknown suite: $SUITE${NOCOLOR}"
        echo "Valid suites: unit, security, integration, all"
        exit 1
        ;;
esac

# Additional checks
echo -e "${YELLOW}[*] Running additional checks...${NOCOLOR}"
echo ""

# ShellCheck (if available)
if command -v shellcheck &> /dev/null; then
    echo -e "${BLUE}  → Running ShellCheck on setup.sh...${NOCOLOR}"
    if shellcheck -S warning setup.sh 2>&1 | grep -v "^$"; then
        echo -e "${GREEN}    ✓ ShellCheck passed${NOCOLOR}"
    else
        echo -e "${RED}    ✗ ShellCheck found issues${NOCOLOR}"
        FAILED=$((FAILED + 1))
    fi
else
    echo -e "${YELLOW}  ⚠ ShellCheck not installed (optional)${NOCOLOR}"
fi

# Syntax check
echo -e "${BLUE}  → Checking bash syntax...${NOCOLOR}"
if bash -n setup.sh; then
    echo -e "${GREEN}    ✓ Syntax check passed${NOCOLOR}"
else
    echo -e "${RED}    ✗ Syntax errors found${NOCOLOR}"
    FAILED=$((FAILED + 1))
fi

# Python syntax
echo -e "${BLUE}  → Checking Python syntax...${NOCOLOR}"
if python3 -m py_compile scripts/whichSystem.py 2>/dev/null; then
    echo -e "${GREEN}    ✓ Python syntax check passed${NOCOLOR}"
else
    echo -e "${RED}    ✗ Python syntax errors found${NOCOLOR}"
    FAILED=$((FAILED + 1))
fi

echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NOCOLOR}"

if [ $FAILED -eq 0 ]; then
    echo -e "${BLUE}║${NOCOLOR}  ${GREEN}✓ ALL TESTS PASSED!${NOCOLOR}                                  ${BLUE}║${NOCOLOR}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NOCOLOR}"
    exit 0
else
    echo -e "${BLUE}║${NOCOLOR}  ${RED}✗ $FAILED TEST SUITE(S) FAILED${NOCOLOR}                            ${BLUE}║${NOCOLOR}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NOCOLOR}"
    exit 1
fi
