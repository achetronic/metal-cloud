#!/usr/bin/env bash
set -eo pipefail

HOST=$1
USER=$2
SSH_PRIVATE_KEY_PATH=$3

# Check virtualization availability
function transfer_installation_script () {
  EXIT_CODE=0

  echo "[···] Transferring installation script"
  scp -i "${SSH_PRIVATE_KEY_PATH}" \
    ./scripts/install-dependencies.sh \
    "${USER}"@"${HOST}":/tmp/install-dependencies.sh 2>/dev/null || EXIT_CODE=$?

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


echo "[···] Installing ñlajkpsaojks"
transfer_installation_script
