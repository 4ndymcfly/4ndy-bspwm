# Keyboard Shortcuts - 4ndy-bspwm

> Configuration optimized for macOS host + Parallels VM

## Applications

| Shortcut | Alternative | Action |
|----------|-------------|--------|
| `Super + Enter` | `Alt + Enter` | Open terminal (kitty) |
| `Super + D` | `Alt + D` | Open launcher (Rofi) |
| `Super + Shift + F` | - | Open Firefox |
| `Super + Shift + B` | - | Open Burpsuite |

## Window Management

| Shortcut | Alternative | Action |
|----------|-------------|--------|
| `Super + W` | `Alt + W` | Close window |
| `Super + Shift + W` | `Alt + Shift + W` | Kill window (force close) |
| `Super + M` | - | Toggle tiled/monocle layout |
| `Super + G` | - | Swap with largest window |
| `Super + Y` | - | Send marked node to preselection |

## Window States

| Shortcut | Alternative | Action |
|----------|-------------|--------|
| `Super + T` | `Alt + T` | Tiled mode |
| `Super + Shift + T` | `Alt + Shift + T` | Pseudo-tiled mode |
| `Super + S` | `Alt + S` | Floating mode |
| `Super + F` | `Alt + F` | Fullscreen mode |

## Window Flags

| Shortcut | Action |
|----------|--------|
| `Super + Ctrl + M` | Mark window |
| `Super + Ctrl + X` | Lock window |
| `Super + Ctrl + Y` | Sticky window |
| `Super + Ctrl + Z` | Private window |

## Window Navigation

| Shortcut | Alternative | Action |
|----------|-------------|--------|
| `Super + Arrows` | `Alt + Arrows` | Focus window in direction |
| `Super + Shift + Arrows` | `Alt + Shift + Arrows` | Swap window in direction |
| `Super + P` | - | Focus parent node |
| `Super + B` | - | Focus sibling node |
| `Super + ,` | - | Focus first child |
| `Super + .` | - | Focus second child |
| `Super + C` | - | Next window in desktop |
| `Super + Shift + C` | - | Previous window in desktop |
| `Super + [` | - | Previous desktop (same monitor) |
| `Super + ]` | - | Next desktop (same monitor) |
| `Super + `` ` `` | - | Last focused window |
| `Super + Tab` | - | Last desktop |
| `Super + O` | - | Older window in history |
| `Super + I` | - | Newer window in history |

## Desktops / Workspaces

### Switch Desktop

| Shortcut | Alternative (macOS) | Action |
|----------|---------------------|--------|
| `Super + 1` | `Alt + F1` | Go to desktop 1 |
| `Super + 2` | `Alt + F2` | Go to desktop 2 |
| `Super + 3` | `Alt + F3` | Go to desktop 3 |
| `Super + 4` | `Alt + F4` | Go to desktop 4 |
| `Super + 5` | `Alt + F5` | Go to desktop 5 |
| `Super + 6` | `Alt + F6` | Go to desktop 6 |
| `Super + 7` | `Alt + F7` | Go to desktop 7 |
| `Super + 8` | `Alt + F8` | Go to desktop 8 |
| `Super + 9` | `Alt + F9` | Go to desktop 9 |
| `Super + 0` | `Alt + F10` | Go to desktop 10 |

### Move Window to Desktop

| Shortcut | Alternative (macOS) | Action |
|----------|---------------------|--------|
| `Super + Shift + 1` | `Alt + Shift + F1` | Move window to desktop 1 |
| `Super + Shift + 2` | `Alt + Shift + F2` | Move window to desktop 2 |
| `Super + Shift + 3` | `Alt + Shift + F3` | Move window to desktop 3 |
| `Super + Shift + 4` | `Alt + Shift + F4` | Move window to desktop 4 |
| `Super + Shift + 5` | `Alt + Shift + F5` | Move window to desktop 5 |
| `Super + Shift + 6` | `Alt + Shift + F6` | Move window to desktop 6 |
| `Super + Shift + 7` | `Alt + Shift + F7` | Move window to desktop 7 |
| `Super + Shift + 8` | `Alt + Shift + F8` | Move window to desktop 8 |
| `Super + Shift + 9` | `Alt + Shift + F9` | Move window to desktop 9 |
| `Super + Shift + 0` | `Alt + Shift + F10` | Move window to desktop 10 |

## Preselection

| Shortcut | Action |
|----------|--------|
| `Super + Ctrl + Alt + Arrows` | Preselect direction for new window |
| `Super + Ctrl + 1-9` | Preselect ratio (0.1 - 0.9) |
| `Super + Ctrl + Alt + Space` | Cancel node preselection |
| `Super + Ctrl + Shift + Space` | Cancel all preselections |

## Resize and Move

| Shortcut | Action |
|----------|--------|
| `Super + Ctrl + Arrows` | Move floating window (20px) |
| `Alt + Super + Arrows` | Resize window |

## System

| Shortcut | Action |
|----------|--------|
| `Super + Escape` | Reload sxhkd configuration |
| `Super + Alt + R` | Restart bspwm |
| `Super + Alt + Q` | Quit bspwm session |
| `Ctrl + Alt + L` | Lock screen (i3lock-fancy) |
| `Ctrl + Alt + P` | Power off (forced - for VMs) |
| `Ctrl + Alt + R` | Reboot system |

## Audio

| Shortcut | Action |
|----------|--------|
| `Ctrl + Shift + Up` | Increase volume (+5%) |
| `Ctrl + Shift + Down` | Decrease volume (-5%) |
| `Ctrl + Shift + M` | Mute/unmute audio |

## Screenshots

| Shortcut | Action |
|----------|--------|
| `Print` | Full screenshot (saves to ~/Screenshots) |
| `Ctrl + Print` | Selection screenshot (Flameshot GUI) |

## Terminal (Kitty)

| Shortcut | Action |
|----------|--------|
| `Ctrl + Shift + Enter` | New split window |
| `Ctrl + Shift + T` | New tab |
| `Ctrl + Shift + W` | Close tab/window |
| `Ctrl + Shift + Z` | Zoom current pane |
| `Ctrl + Arrows` | Navigate between panes |
| `Ctrl + Shift + C` | Copy |
| `Ctrl + Shift + V` | Paste |
| `F1` / `F2` | Copy/Paste buffer A |
| `F3` / `F4` | Copy/Paste buffer B |

---

## Monitor Configuration (Parallels)

| Monitor | Position | Desktops |
|---------|----------|----------|
| Virtual-1 | Right (primary) | 1, 2, 3, 4, 5 |
| Virtual-2 | Left (secondary) | 6, 7, 8, 9, 10 |

---

> **Note:** Shortcuts with `Alt` are macOS-compatible alternatives, where `Super` (Cmd) may be intercepted by the host system.
