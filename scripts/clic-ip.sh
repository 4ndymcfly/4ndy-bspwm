#!/bin/bash

# FIX: Migrate from deprecated ifconfig to ip command
# FIX: Auto-detect primary ethernet interface instead of hardcoded eth0
ETH_IFACE=$(ip route | grep default | awk '{print $5}' | head -n1)
if [ -n "$ETH_IFACE" ]; then
	ip -4 addr show "$ETH_IFACE" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1 | tr -d '\n' | xclip -sel clip
fi
