#!/bin/sh

# FIX: Migrate from deprecated ifconfig to ip command
ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1 | tr -d '\n' | xclip -sel clip
