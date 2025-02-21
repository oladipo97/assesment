#! /usr/bin/env bash

DEV_PRIVATE_KEY=$(wg genkey)
DEV_PUBLIC_KEY=$(echo $DEV_PRIVATE_KEY | wg pubkey)
STAGING_PRIVATE_KEY=$(wg genkey)
STAGING_PUBLIC_KEY=$(echo $STAGING_PRIVATE_KEY | wg pubkey)
PRODUCTION_PRIVATE_KEY=$(wg genkey)
PRODUCTION_PUBLIC_KEY=$(echo $PRODUCTION_PRIVATE_KEY | wg pubkey)

read -r -d '' DEV_CLIENT_CONFIG << EOM
[Interface]
PrivateKey = ${DEV_PRIVATE_KEY}
Address = 192.168.100.${LAST_IP_OCTET}/32
# DNS = 1.1.1.1, 1.0.0.1

[Peer]
PublicKey = 5+gh/YV87e1xsaHmklh1NL0xFgV8oIn+IbWLbSu+D2A=
AllowedIPs = 192.168.100.0/24, 10.50.0.0/15, 10.52.0.0/14, 10.56.0.0/13, 10.64.0.0/11, 10.96.0.0/14, 10.0.0.0/16
Endpoint = dev.vpn.120water.com:51820
PersistentKeepalive = 25
EOM

read -r -d '' STAGING_CLIENT_CONFIG << EOM
[Interface]
PrivateKey = ${STAGING_PRIVATE_KEY}
Address = 192.168.105.${LAST_IP_OCTET}/32
# DNS = 1.1.1.1, 1.0.0.1

[Peer]
PublicKey = 5v2tKgamHEr55r4xl3PnfTySAXiELWCSsuOvruOIe28=
AllowedIPs = 192.168.105.0/24, 10.100.0.0/14, 10.104.0.0/13, 10.112.0.0/12, 10.128.0.0/12, 10.144.0.0/14, 10.148.0.0/15, 10.0.0.0/16
Endpoint = staging.vpn.120water.com:51820
PersistentKeepalive = 25
EOM

read -r -d '' PRODUCTION_CLIENT_CONFIG << EOM
[Interface]
PrivateKey = ${PRODUCTION_PRIVATE_KEY}
Address = 192.168.110.${LAST_IP_OCTET}/32
# DNS = 1.1.1.1, 1.0.0.1

[Peer]
PublicKey = 0My8Il10LVsH103f/v7WVYoqrDsqzv2J3mh8kcYOGFw=
AllowedIPs = 192.168.110.0/24, 10.150.0.0/15, 10.152.0.0/13, 10.160.0.0/11, 10.192.0.0/13, 10.0.0.0/16
Endpoint = production.vpn.120water.com:51820
PersistentKeepalive = 25
EOM

echo "$DEV_CLIENT_CONFIG" >"120Water Dev.conf"
echo "$STAGING_CLIENT_CONFIG" >"120Water Staging.conf"
echo "$PRODUCTION_CLIENT_CONFIG" >"120Water Production.conf"
zip "/data/VPN Config - ${USERNAME}.zip" "120Water Dev.conf" "120Water Staging.conf" "120Water Production.conf"

cat << EOM
Terraform config:

Dev:
{ public_key = "${DEV_PUBLIC_KEY}", last_ip_octet = ${LAST_IP_OCTET}, comment = "${USERNAME}" },

Staging:
{ public_key = "${STAGING_PUBLIC_KEY}", last_ip_octet = ${LAST_IP_OCTET}, comment = "${USERNAME}" },

Production:
{ public_key = "${PRODUCTION_PUBLIC_KEY}", last_ip_octet = ${LAST_IP_OCTET}, comment = "${USERNAME}" },
EOM
