# Quick Start Guide - Test Suite

Get started with testing in 5 minutes!

## 📦 Install Bats

```bash
sudo apt update
sudo apt install bats
```

## ▶️ Run All Tests

```bash
# Simple way
bats tests/*.bats

# Or use our convenience script
./tests/run_tests.sh
```

## 🎯 Run Specific Tests

```bash
# Unit tests only
bats tests/test_setup.bats

# Security tests only
bats tests/test_security.bats

# Integration tests only
bats tests/test_integration.bats

# Run tests matching a keyword
bats tests/test_setup.bats --filter "version"
```

## 📊 Expected Output

```
 ✓ setup.sh file exists
 ✓ setup.sh is executable
 ✓ LSD version is 1.2.0 or higher
 ✓ Go version is 1.23.5 or higher
 ✓ Zsh plugins are included (FIX verification)
 ✓ [SECURITY] No unquoted variable expansions
 ✓ [SECURITY] All downloads use HTTPS
 ✓ [INTEGRATION] All required directories exist

144 tests, 0 failures
```

## ✅ What Gets Tested?

- ✅ **Security** (40 tests)
  - Command injection prevention
  - Proper variable quoting
  - No hardcoded secrets
  - HTTPS-only downloads

- ✅ **Functionality** (73 tests)
  - All dependencies listed
  - Correct installation order
  - Proper error handling
  - Version validation

- ✅ **Integration** (31 tests)
  - File operations work
  - Script flow is correct
  - Cleanup procedures
  - URL accessibility

## 🚀 CI/CD (Automatic Testing)

Tests run automatically on GitHub when you:
- Push to main/master branch
- Create a pull request
- Manually trigger workflow

See results in: **Actions** tab on GitHub

## 🐛 If Tests Fail

1. **Read the error message** - it tells you exactly what's wrong
2. **Check the line number** - shows where the problem is
3. **Run just that test** - easier to debug
   ```bash
   bats tests/test_setup.bats --filter "failing test name"
   ```

## 📚 Learn More

See full documentation: [tests/README.md](README.md)

## 💡 Pro Tips

```bash
# Pretty output with colors
bats tests/*.bats --pretty

# Show timing for slow tests
bats tests/*.bats --timing

# Verbose output (see everything)
bats tests/*.bats --verbose

# Count tests without running
grep -c "^@test" tests/*.bats
```

## 🎓 Example Workflow

```bash
# 1. Make changes to setup.sh
vim setup.sh

# 2. Run tests to verify nothing broke
./tests/run_tests.sh

# 3. If tests pass, commit
git add setup.sh
git commit -m "Updated setup.sh"

# 4. Push - CI will run automatically
git push
```

---

**That's it! Happy testing! 🧪**
