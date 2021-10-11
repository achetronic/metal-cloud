#!/usr/bin/env bash
set -eo pipefail

HOST=$1
USERNAME=$2
PASSWORD=$3

# Check virtualization availability
function transfer_public_key () {
  EXIT_CODE=0

  echo "[···] Transferring public key to the host"
  ssh-copy-id "$USERNAME:$PASSWORD@$HOST" 2>/dev/null || EXIT_CODE=$?

  case $EXIT_CODE in
  0)
    # All ok
    ;;
  *)
    # Other errors
    echo "[ERROR] Impossible to perform this action"
    exit $EXIT_CODE
    ;;
  esac
}


echo "[···] Installing public key on the host"
transfer_public_key
