# ============================================================================
# LAYERS · EP.02 — MikroTik voucher network
# SANITIZED REFERENCE EXTRACT — NOT IMPORTABLE
# ----------------------------------------------------------------------------
# Purpose: illustrate the engineering structure only.
# All operational values are placeholders. This is not the original config,
# not a full template, and not a ready-to-import file.
#
# Removed from public material:
#   subscriber/voucher accounts, passwords, secrets, client identity,
#   SSID, device serial/license ID, DDNS name, admin address lists,
#   IP bindings, routes/services, VPN/RADIUS endpoints, Telegram destinations.
# ============================================================================

# --- VLAN plan (reference) ---------------------------------------------------
/interface bridge
add name=bridge1 vlan-filtering=yes comment="VLAN-aware bridge (reference)"

/interface vlan
add interface=bridge1 name=vlan10 vlan-id=10
add interface=bridge1 name=vlan15 vlan-id=15
add interface=bridge1 name=vlan20 vlan-id=20
add interface=bridge1 name=vlan25 vlan-id=25
add interface=bridge1 name=vlan30 vlan-id=30
add interface=bridge1 name=vlan35 vlan-id=35
add interface=bridge1 name=vlan40 vlan-id=40
add interface=bridge1 name=vlan45 vlan-id=45
add interface=bridge1 name=vlan50 vlan-id=50
add interface=bridge1 name=vlan55 vlan-id=55
add interface=bridge1 name=vlan60 vlan-id=60
add interface=bridge1 name=vlan65 vlan-id=65
add interface=bridge1 name=vlan70 vlan-id=70
add interface=bridge1 name=vlan75 vlan-id=75
add interface=bridge1 name=vlan80 vlan-id=80
add interface=bridge1 name=vlan85 vlan-id=85
add interface=bridge1 name=vlan90 vlan-id=90
add interface=bridge1 name=vlan95 vlan-id=95
add interface=bridge1 name=vlan100 vlan-id=100

/interface bridge vlan
add bridge=bridge1 tagged=bridge1,<UPLINK-PORT> vlan-ids=10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100

# --- Bandwidth control (example for one VLAN) -------------------------------
/queue type
add kind=pcq name=pcq-download pcq-classifier=dst-address
add kind=pcq name=pcq-upload pcq-classifier=src-address

/ip firewall mangle
add chain=prerouting action=mark-packet new-packet-mark=user_down_mark_vlan10 passthrough=yes comment="Example: download mark for VLAN10"
add chain=postrouting action=mark-packet new-packet-mark=user_up_mark_vlan10 passthrough=yes comment="Example: upload mark for VLAN10"

/queue tree
add max-limit=3M name=vlan10_down packet-mark=user_down_mark_vlan10 parent=global queue=pcq-download
add max-limit=7M name=vlan10_up packet-mark=user_up_mark_vlan10 parent=global queue=pcq-upload

# --- Login portal and plan (placeholders) -----------------------------------
/ip hotspot profile
add name=hsprof1 hotspot-address=<GATEWAY-IP> dns-name=<PORTAL-DOMAIN> html-directory=<PORTAL-DIR> login-by=http-pap

/ip hotspot user profile
add name=TIER-EXAMPLE rate-limit=<RATE-LIMIT> session-timeout=<SESSION-TIMEOUT> on-login="<EXPIRY-LOGIC>"

# --- Scheduled validity check (placeholder) ---------------------------------
/system scheduler
add name=check-expiry interval=<INTERVAL> on-event="<CHECK-EXPIRED-VOUCHERS>"

# Actual logic, described without executable detail:
# 1. On first login, compute validity from the plan and store expiry in the account record.
# 2. A scheduled task checks accounts for the configured plans.
# 3. Expired voucher accounts are removed from the Hotspot user list.
# 4. Monitoring scripts send device/traffic summaries to Telegram; destinations are not published.
