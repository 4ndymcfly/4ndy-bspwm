#!/bin/sh

# FIX: Migrate from deprecated ifconfig to ip command
# FIX: Auto-detect primary ethernet interface instead of hardcoded eth0
ETH_IFACE=$(ip route | grep default | awk '{print $5}' | head -n1)
if [ -n "$ETH_IFACE" ]; then
	ETH_IP=$(ip -4 addr show "$ETH_IFACE" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1)
	echo "%{F#ffffff}  %{F#ffffff}${ETH_IP}%{u-}"
else
	echo "%{F#ffffff}  %{F#ffffff}N/A%{u-}"
fi
