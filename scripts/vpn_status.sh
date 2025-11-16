#!/bin/sh

# FIX: Migrate from deprecated ifconfig to ip command
IFACE=$(ip link show tun0 2>/dev/null | grep -o "tun0" | head -n1)

if [ "$IFACE" = "tun0" ]; then
	VPN_IP=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
	echo "%{F#ffffff}  %{F#ffffff}${VPN_IP}%{u-}"
else
	echo "%{F#ffffff} %{u-} Disconnected"
fi
