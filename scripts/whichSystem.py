#!/usr/bin/python3
#coding: utf-8

import re, sys, subprocess

# python3 wichSystem.py 10.10.10.188

def get_ttl(ip_address):
    try:
        # FIX: Use list of arguments instead of shell=True to prevent command injection
        proc = subprocess.Popen(["/usr/bin/ping", "-c", "1", ip_address],
                                stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE,
                                shell=False)
        (out, err) = proc.communicate()

        if proc.returncode != 0:
            return None

        # FIX: Parse TTL using regex instead of hardcoded index
        out_str = out.decode('utf-8')
        ttl_match = re.search(r'ttl=(\d+)', out_str, re.IGNORECASE)

        if ttl_match:
            return ttl_match.group(1)
        else:
            return None

    except Exception as e:
        print(f"\n[!] Error al ejecutar ping: {e}\n")
        return None

def get_os(ttl):
    if ttl is None:
        return "Unknown (host no responde)"

    ttl = int(ttl)

    # FIX: Correct TTL ranges
    # Linux/Unix typically use TTL 64
    # Windows typically use TTL 128
    # Routers decrement TTL, so we check ranges around typical values
    if ttl > 0 and ttl <= 64:
        return "Linux"
    elif ttl > 64 and ttl <= 128:
        return "Windows"
    else:
        return "Not Found"

if __name__ == '__main__':
    # Validate command line arguments
    if len(sys.argv) != 2:
        print("\n[!] Uso: python3 " + sys.argv[0] + " <direccion-ip>\n")
        sys.exit(1)

    ip_address = sys.argv[1]

    ttl = get_ttl(ip_address)

    os_name = get_os(ttl)
    print("\n\t%s (ttl -> %s): %s" % (ip_address, ttl if ttl else "N/A", os_name))
