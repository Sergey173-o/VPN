#!/usr/bin/env bash
# Создаёт CA, сертификаты сервера и клиента и ключ tls-crypt для RAS.
set -euo pipefail
umask 077

export EASYRSA_BATCH=1
export EASYRSA_PKI=/etc/openvpn/otus/pki
easyrsa=/usr/share/easy-rsa/easyrsa

# При повторном запуске сохраняем уже выпущенные сертификаты.
if [[ ! -d "$EASYRSA_PKI" ]]; then
  "$easyrsa" init-pki
fi
if [[ ! -s "$EASYRSA_PKI/ca.crt" ]]; then
  EASYRSA_REQ_CN=OTUS-VPN-Lab "$easyrsa" build-ca nopass
fi
for role in server client; do
  name="ras-$role"
  if [[ ! -s "$EASYRSA_PKI/issued/$name.crt" ]]; then
    if [[ ! -s "$EASYRSA_PKI/reqs/$name.req" ]]; then
      "$easyrsa" gen-req "$name" nopass
    fi
    "$easyrsa" sign-req "$role" "$name"
  fi
done
if [[ ! -s /etc/openvpn/otus/ras-tls.key ]]; then
  openvpn --genkey --secret /etc/openvpn/otus/ras-tls.key
fi
# Версия 1 | 2026-11-09 | Выпуск сертификатов для RAS.
