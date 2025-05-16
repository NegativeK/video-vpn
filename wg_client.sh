#!/bin/bash

# If passed, parse a wireguard quick config file for values.
# wg-quick would be faster, but it has some requirements that require extra
# work -- resolvconf, sysctl -- in a container.
if [ -n "$1" ]; then
  CONF_FILE=$(<"$1")
  VPN_PRIVATE_KEY=$(echo "$CONF_FILE" | grep PrivateKey | cut -d " " -f 3)
  VPN_SERVER_PUBKEY=$(echo "$CONF_FILE" | grep PublicKey | cut -d " " -f 3)
  VPN_SERVER_IP=$(echo "$CONF_FILE" | grep Endpoint | cut -d " " -f 3 | cut -d ":" -f 1)
  VPN_SERVER_PORT=$(echo "$CONF_FILE" | grep Endpoint | cut -d ":" -f 2)
  VPN_CLIENT_IP=$(echo "$CONF_FILE" | grep Address | cut -d " " -f 3)
  NAMESERVER=$(echo "$CONF_FILE" | grep DNS | cut -d " " -f 3)
fi

ip link del dev wg0 2>/dev/null || true
ip link add dev wg0 type wireguard
wg set wg0 \
  private-key <(echo "$VPN_PRIVATE_KEY") \
  peer "$VPN_SERVER_PUBKEY" \
  endpoint "$VPN_SERVER_IP:$VPN_SERVER_PORT" \
  allowed-ips 0.0.0.0/0 \
  persistent-keepalive 25
ip address add "$VPN_CLIENT_IP" dev wg0
ip link set up dev wg0

ip route add $(ip route get $VPN_SERVER_IP | cut -d " " -f 1-3)

ip route delete default
ip route add default dev wg0

echo "nameserver $NAMESERVER" >/etc/resolv.conf
