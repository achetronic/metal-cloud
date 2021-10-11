#!/usr/bin/env bash
set -eo pipefail

HOST=$1
SSH_PRIVATE_KEY_PATH=$2
USERNAME=$3
PASSWORD=$4

#
function execute_installation_script () {
  EXIT_CODE=0

  echo "[···] Executing installation script"
  ssh -i "${SSH_PRIVATE_KEY_PATH}" "${USERNAME}"@"${HOST}" \
    "echo $PASSWORD | sudo -S bash /tmp/install-dependencies.sh $USERNAME"  || EXIT_CODE=$?

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

echo "[···] Executing installation script"
execute_installation_script


