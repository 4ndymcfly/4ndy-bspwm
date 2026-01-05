# ARM64/macOS Configuration Files

> **⚠️ IMPORTANT:** These configuration files are optimized for a specific setup:
> - **Host OS:** macOS Sequoia (v26)
> - **Virtualization:** Parallels Desktop
> - **Monitors:** Dual 4K displays (2560x1440 each)
> - **Keyboard:** Non-Apple keyboard (standard PC layout)
>
> If your setup differs, you may need to adjust the configurations.

This folder contains configuration files optimized for running bspwm on ARM64 architecture (Apple Silicon) with Parallels Desktop or other hypervisors.

## When are these configs used?

The `setup.sh` script automatically detects:
- **Architecture**: `aarch64` or `arm64`
- **Hypervisor**: Parallels, VMware, VirtualBox, etc.

If ARM64 or a VM is detected, these configs override the default ones.

## Key differences from standard config

| File | Change | Reason |
|------|--------|--------|
| `picom/picom.conf` | `backend = "xrender"` | GLX has issues with virgl in VMs |
| `picom/picom.conf` | `vsync = false` | Better VM compatibility |
| `bspwm/bspwmrc` | Hypervisor detection | Auto-starts prlcc, vmware-user, etc. |
| `bspwm/bspwmrc` | Monitor wait loop | Waits for dual monitors in Parallels |
| `bspwm/bspwmrc` | Dual monitor setup | Virtual-1 (right), Virtual-2 (left) |
| `polybar/launch.sh` | Multi-monitor support | Launches polybar on each monitor |
| `sxhkd/sxhkdrc` | `Alt + F1-F10` | macOS intercepts Super+numbers |

## Keyboard shortcuts for macOS host

Since macOS intercepts many keyboard shortcuts, alternative bindings are provided:

| Action | Standard | macOS Alternative |
|--------|----------|-------------------|
| Switch desktop | `Super + 1-0` | `Alt + F1-F10` |
| Move window | `Super + Shift + 1-0` | `Alt + Shift + F1-F10` |
| Terminal | `Super + Enter` | `Alt + Enter` |
| Launcher | `Super + D` | `Alt + D` |
| Close window | `Super + W` | `Alt + W` |

See `SHORTCUTS.md` in the root directory for a complete list.

## Apple Keyboard Users

If you're using an **original Apple keyboard**, the key mapping is different:

| Key | Apple Keyboard | Standard PC Keyboard |
|-----|----------------|---------------------|
| Super (⌘) | Command | Windows/Super |
| Alt (⌥) | Option | Alt |

The standard x86 configuration uses `Super` as the leader key. On Apple keyboards connected to a VM, you may need to:

1. Edit `sxhkd/sxhkdrc`
2. Swap `super` and `alt` modifiers
3. Or configure Parallels to remap keys

Example change in sxhkdrc:
```bash
# Before (PC keyboard)
super + Return
    /usr/bin/kitty

# After (Apple keyboard - if needed)
alt + Return
    /usr/bin/kitty
```

## Manual installation

If you want to apply these configs manually:

```bash
cp -r config-arm64/* ~/.config/
```

## Monitor configuration

Default setup for Parallels dual-monitor:
- **Virtual-1** (right, primary): Desktops 1-5
- **Virtual-2** (left, secondary): Desktops 6-10

To change this, edit `bspwm/bspwmrc` lines 41-42.
