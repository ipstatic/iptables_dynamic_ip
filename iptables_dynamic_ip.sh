#!/bin/bash

ROUTER_IP=$(dig +short router.example.com)
FOUND=0

for ip in $(/sbin/iptables -nL DYNAMIC | awk '$4 ~ /^[0-9]/ { print $4}'); do
  if [ "${ip}" = "${ROUTER_IP}" ]; then
    echo "${ROUTER_IP} found in DYMAIC chain"
    FOUND=$((FOUND + 1))
  fi
done

if [ $FOUND -eq 0 ]; then
  # Our IP must have changed. Let's drop the table and re-create it with the new
  # IP
  echo "did not find ${ROUTER_IP} in DYNAMIC chain"

  echo "clearing rules in DYNAMIC chain"
  /sbin/iptables -F DYNAMIC
  if [ $? -gt 0 ]; then
    echo "could not clear rules in DYNAMIC chain"
    exit 1
  fi

  echo "adding ${ROUTER_IP} to DYNAMIC chain"
  /sbin/iptables -A DYNAMIC -s $ROUTER_IP -j ACCEPT
  if [ $? -gt 0 ]; then
    echo "could not add ${ROUTER_IP} to DYNAMIC chain"
    exit 1
  fi

fi
