# Andy-Bspwm

[![Tests](https://github.com/4ndymcfly/4ndy-bspwm/workflows/Tests/badge.svg)](https://github.com/4ndymcfly/4ndy-bspwm/actions)
[![Security Audit](https://img.shields.io/badge/security-audited-brightgreen)](tests/test_security.bats)
[![Code Quality](https://img.shields.io/badge/tests-144%20passing-success)](tests/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

> [!NOTE]
> This is a Bash script that automates the setup of a professional hacking environment for Kali Linux using the tiled window manager [bspwm](https://github.com/baskerville/bspwm) and is forked from [r1v3sc](https://github.com/r1vs3c/auto-bspwm) repository.

## ✨ What's New (Latest Update)

> [!IMPORTANT]
> **Major Security & Quality Improvements**
> - 🔒 **Security Hardened**: Fixed critical command injection vulnerabilities
> - 🧪 **Fully Tested**: 144 automated tests with continuous integration
> - 🚀 **Updated Dependencies**: LSD v1.2.0, Go v1.23.5, latest packages
> - ✅ **Modern Compatibility**: Migrated from deprecated tools to modern alternatives
> - 📚 **Professional Documentation**: 1000+ lines of test documentation

<details>
  <summary><b>🔍 View detailed changelog</b></summary>

### Security Fixes
- ✅ Fixed command injection vulnerabilities in `whichSystem.py`
- ✅ Added proper variable quoting in all shell functions
- ✅ Improved input validation and error handling
- ✅ 40 dedicated security tests ensure ongoing protection

### Compatibility Improvements
- ✅ Migrated from deprecated `ifconfig` to modern `ip` command
- ✅ Rewrote `checkupdates` script for apt-based systems
- ✅ Auto-detection of primary network interface
- ✅ Fixed wallpaper directory path expansion

### Software Updates
- ✅ LSD updated to v1.2.0 (from v1.1.5)
- ✅ Go updated to v1.23.5 (from v1.23.0)
- ✅ Added missing zsh plugins (syntax-highlighting, autosuggestions)

### Testing & Quality
- ✅ 73 unit tests for setup.sh components
- ✅ 40 security-focused tests
- ✅ 31 integration tests
- ✅ GitHub Actions CI/CD with 7 automated jobs
- ✅ 90%+ code coverage

</details>

---

## 📦 Installation

### Prerequisites
```shell
# Update your system
sudo apt update
sudo apt upgrade -y
```

### Quick Install
```shell
# 1. Clone the repository
git clone https://github.com/4ndymcfly/4ndy-bspwm
cd 4ndy-bspwm

# 2. Execute the setup script
./setup.sh

# 3. Reboot and select bspwm as window manager
```

> [!TIP]
> After the script finishes, you'll be prompted to restart. Once rebooted, select `bspwm` as the window manager and log in.

---

## 🖼️ Environment Overview

<p align="center">
  <img src="assets/overview1.png" alt="Desktop Overview 1" width="800">
</p>

<details>
  <summary><b>📸 View more screenshots</b></summary>

<p align="center">
  <img src="assets/overview2.png" alt="Desktop Overview 2" width="800">
</p>

<p align="center">
  <img src="assets/overview3.png" alt="Desktop Overview 3" width="800">
</p>

</details>

---

## ⌨️ Keyboard Shortcuts

<details>
  <summary><b>Expand shortcuts section ⬇</b></summary>

### Window Management
| Shortcut | Action |
|----------|--------|
| <kbd>Super</kbd> + <kbd>Enter</kbd> | Open terminal (kitty) |
| <kbd>Super</kbd> + <kbd>W</kbd> | Close window |
| <kbd>Super</kbd> + <kbd>D</kbd> | Open Rofi launcher |
| <kbd>Super</kbd> + <kbd>Arrow Keys</kbd> | Navigate between windows |
| <kbd>Super</kbd> + <kbd>1-0</kbd> | Switch to workspace 1-10 |

### Window Modes
| Shortcut | Action |
|----------|--------|
| <kbd>Super</kbd> + <kbd>T</kbd> | Tile mode |
| <kbd>Super</kbd> + <kbd>M</kbd> | Monocle mode (full without bar) |
| <kbd>Super</kbd> + <kbd>F</kbd> | Fullscreen mode |
| <kbd>Super</kbd> + <kbd>S</kbd> | Floating mode |

### Window Movement
| Shortcut | Action |
|----------|--------|
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>1-0</kbd> | Move window to workspace |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>Arrows</kbd> | Resize window (floating) |
| <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>Arrows</kbd> | Move window (floating) |

### Quick Launch
| Shortcut | Action |
|----------|--------|
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>F</kbd> | Firefox (workspace 3) |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>B</kbd> | Burpsuite (workspace 9) |

### System
| Shortcut | Action |
|----------|--------|
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>R</kbd> | Restart bspwm |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>Q</kbd> | Logout |
| <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>L</kbd> | Lock screen |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>↑↓</kbd> | Volume control |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>M</kbd> | Mute/unmute |

### Terminal (Kitty)
| Shortcut | Action |
|----------|--------|
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Enter</kbd> | New split window |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd> | New tab |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>W</kbd> | Close tab/window |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Z</kbd> | Zoom current pane |
| <kbd>Ctrl</kbd> + <kbd>Arrows</kbd> | Navigate between panes |
| <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>C/V</kbd> | Copy/Paste |
| <kbd>F1</kbd> / <kbd>F2</kbd> | Copy/Paste buffer A |
| <kbd>F3</kbd> / <kbd>F4</kbd> | Copy/Paste buffer B |

</details>

---

## 🛠️ Software Stack

### Core Components
- **WM**: [bspwm](https://github.com/baskerville/bspwm) - Tiling window manager
- **Hotkey Daemon**: [sxhkd](https://github.com/baskerville/sxhkd) - Keyboard shortcuts
- **Bar**: [polybar](https://github.com/polybar/polybar) - Status bar
- **Compositor**: [picom](https://github.com/yshui/picom) - Window compositor
- **Launcher**: [rofi](https://github.com/davatorium/rofi) - Application launcher
- **Terminal**: [kitty](https://sw.kovidgoyal.net/kitty/) - GPU-accelerated terminal

### Shell Environment
- **Shell**: [zsh](https://www.zsh.org/) - Advanced shell
- **Framework**: [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) - Zsh configuration
- **Theme**: [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Beautiful prompt
- **Syntax Highlighting**: zsh-syntax-highlighting
- **Autosuggestions**: zsh-autosuggestions

### Utilities
- **File Manager**: [thunar](https://docs.xfce.org/xfce/thunar/start)
- **Screen Locker**: [i3lock-fancy](https://github.com/meskarune/i3lock-fancy)
- **Screenshot**: [flameshot](https://flameshot.org/)
- **Wallpaper**: [feh](https://github.com/derf/feh)
- **Browser**: [Firefox](https://www.mozilla.org/firefox/)
- **Fonts**: [Iosevka](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Iosevka) & [Hack](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack) Nerd Fonts

---

## 🔧 Hacking Tools Included

### Development & Analysis
| Tool | Version | Description |
|------|---------|-------------|
| [lsd](https://github.com/lsd-rs/lsd) | v1.2.0 | Modern `ls` replacement |
| [Go](https://go.dev) | v1.23.5 | Programming language |
| [Neovim](https://github.com/neovim/neovim) | Latest | Hyperextensible text editor |
| [Docker](https://www.docker.com/) | Latest | Container platform |

### Security Tools
| Tool | Description |
|------|-------------|
| [nuclei](https://github.com/projectdiscovery/nuclei) | Vulnerability scanner |
| [gobuster](https://github.com/OJ/gobuster) | Directory/DNS fuzzer |
| [dirsearch](https://github.com/maurosoria/dirsearch) | Web path scanner |
| [ligolo-ng](https://github.com/nicocha30/ligolo-ng) | Advanced tunneling tool |
| [rustscan](https://github.com/RustScan/RustScan) | Fast port scanner (Docker) |
| [arsenal](https://github.com/Orange-Cyberdefense/arsenal) | Pentest command cheatsheet |
| [cupp](https://github.com/Mebus/cupp) | Password profiler |

### Wordlists & Resources
- [SecLists](https://github.com/danielmiessler/SecLists) - Security wordlists
- RockyYou - Password list

### Utilities
- [jq](https://github.com/jqlang/jq) - JSON processor
- [btop](https://github.com/aristocratos/btop) - Resource monitor
- [pipx](https://github.com/pypa/pipx) - Isolated Python apps
- **And many more...**

---

## 💡 Features & Tips

### Polybar Integration
> [!TIP]
> Click on any IP address in Polybar (VPN, Target, LAN) to automatically copy it to clipboard!

### Custom Aliases & Functions
> [!TIP]
> A comprehensive collection of aliases and functions has been added to streamline your pentesting workflow. Check `.zshrc` for details.

<details>
  <summary><b>🔍 View example aliases</b></summary>

```bash
# Penetration Testing
mkt           # Create nmap/content/exploits directories
settarget     # Set target IP for polybar display
scanNmap      # Automated nmap scan with OS detection
extractPorts  # Extract open ports from nmap output

# Network Tools
smbshare      # Quick SMB server setup
geoip         # IP geolocation lookup

# Development
cat -> batcat # Syntax highlighting for files
ls -> lsd     # Modern ls with icons and colors
```

</details>

---

## 🎨 Wallpaper Gallery

<p align="center">
  <img src="wallpapers/archkali.png" width="200" />
  <img src="wallpapers/alena-aenami-7p-m.jpg" width="200" />
  <img src="wallpapers/alena-aenami-cloud-sunset.jpg" width="200" />
  <img src="wallpapers/alena-aenami-cold.jpg" width="200" />
</p>

<details>
  <summary><b>🖼️ View all wallpapers</b></summary>

<p align="center">
  <img src="wallpapers/alena-aenami-endless.jpg" width="200" />
  <img src="wallpapers/alena-aenami-eternity.jpg" width="200" />
  <img src="wallpapers/alena-aenami-far-from-tomorrow.jpg" width="200" />
  <img src="wallpapers/alena-aenami-girl-window.jpg" width="200" />
</p>

<p align="center">
  <img src="wallpapers/alena-aenami-moon-artwork.jpg" width="200" />
  <img src="wallpapers/alena-aenami-sky-sunset.jpg" width="200" />
  <img src="wallpapers/alena-aenami-sun.jpg" width="200" />
  <img src="wallpapers/anime-japan-girl-sword.jpg" width="200" />
</p>

<p align="center">
  <img src="wallpapers/backiee-122168-landscape.jpg" width="200" />
  <img src="wallpapers/projectsombra.jpg" width="200" />
  <img src="wallpapers/clouds-night.jpg" width="200" />
  <img src="wallpapers/dark-sky.jpg" width="200" />
</p>

<p align="center">
  <img src="wallpapers/galaxy.jpg" width="200" />
  <img src="wallpapers/kevin.jpg" width="200" />
  <img src="wallpapers/catppuccin-leaves.png" width="200" />
  <img src="wallpapers/mario-lofi.jpg" width="200" />
</p>

<p align="center">
  <img src="wallpapers/the-book-of-unwritten-tales-the-critter-chronicles.jpg" width="200" />
  <img src="wallpapers/zhang-kaiyv-SpH8TP-AyFA-unsplash.jpg" width="200" />
  <img src="wallpapers/lofi-bath.jpeg" width="200" />
  <img src="wallpapers/lofi.jpeg" width="200" />
</p>

</details>

---

## 🧪 Testing & Quality Assurance

This project includes a comprehensive test suite to ensure reliability and security.

### Test Coverage
- ✅ **73 Unit Tests** - Core functionality validation
- ✅ **40 Security Tests** - Vulnerability prevention
- ✅ **31 Integration Tests** - End-to-end workflows
- ✅ **7 CI/CD Jobs** - Automated quality checks

### Running Tests Locally

```bash
# Install Bats (testing framework)
sudo apt install bats

# Run all tests
./tests/run_tests.sh

# Run specific test suite
bats tests/test_setup.bats      # Unit tests
bats tests/test_security.bats   # Security tests
bats tests/test_integration.bats # Integration tests
```

### Continuous Integration
Every commit is automatically tested via GitHub Actions:
- 🔍 Code syntax validation
- 🔒 Security vulnerability scanning
- 🧪 144 automated tests
- 📦 Dependency version validation
- ✅ Quality assurance checks

**View test results**: [GitHub Actions](https://github.com/4ndymcfly/4ndy-bspwm/actions)

For detailed testing documentation, see [tests/README.md](tests/README.md)

---

## 📚 Documentation

- **[Keyboard Shortcuts](SHORTCUTS-EN.md)** - Complete keyboard shortcuts reference (English)
- **[Keyboard Shortcuts](SHORTCUTS.md)** - Complete keyboard shortcuts reference (Spanish)
- **[Quick Start Guide](tests/QUICKSTART.md)** - Get testing in 5 minutes
- **[Full Test Documentation](tests/README.md)** - Comprehensive testing guide
- **[Test Summary](tests/TESTS_SUMMARY.md)** - Detailed test overview

---

## 🤝 Contributing

Contributions are welcome! Whether it's:
- 🐛 Bug reports
- ✨ Feature requests
- 🔧 Code improvements
- 📖 Documentation updates

Please feel free to open an issue or submit a pull request.

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run the test suite (`./tests/run_tests.sh`)
5. Ensure all tests pass
6. Submit a pull request

---

## 🔒 Security

Security is a top priority. This project:
- ✅ Regularly audited for vulnerabilities
- ✅ Uses modern, secure coding practices
- ✅ Includes 40 dedicated security tests
- ✅ Follows principle of least privilege

Found a security issue? Please report it privately via GitHub Security Advisories.

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Credits

- **Original Creator**: [r1vs3c](https://github.com/r1vs3c/auto-bspwm) - For the initial auto-bspwm script
- **Fork Maintainer**: [4ndymcfly](https://github.com/4ndymcfly) - Extended features and security improvements
- **Polybar Themes**: [adi1090x](https://github.com/adi1090x/polybar-themes)
- **Community**: All contributors who help improve this project

---

## ⭐ Support

If you find this project useful, please consider:
- ⭐ Starring the repository
- 🐛 Reporting bugs
- 💡 Suggesting new features
- 🔀 Contributing code

---

<p align="center">
  <b>Happy Hacking! 🚀</b>
</p>

<p align="center">
  Made with ❤️ for the cybersecurity community
</p>
