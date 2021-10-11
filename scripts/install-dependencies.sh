#!/usr/bin/env bash
set -eo pipefail

# Steps are taken from official Ubuntu website
# Ref: https://ubuntu.com/server/docs/virtualization-libvirt

USERNAME=$1

# Check virtualization availability
function check_kvm () {
  EXIT_CODE=0

  echo "[···] Checking KVM availability"
  kvm-ok 2>/dev/null || EXIT_CODE=$?

  case $EXIT_CODE in
  0)
    # All ok
    ;;
  *)
    # Other errors
    echo "[ERROR] KVM not available"
    exit $EXIT_CODE
    ;;
  esac
}

# Update the repositories packages list
function update_packages_list () {
  EXIT_CODE=0

  echo "[···] Updating packages lists"
  apt-get --quiet update 2>/dev/null || EXIT_CODE=$?

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

# Install virtualization components
function install_virtualization_packages () {
  EXIT_CODE=0

  echo "[···] Installing virtualization packages"
  apt-get --quiet --assume-yes install \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils 2>/dev/null || EXIT_CODE=$?

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


# Add user to libvirt group
function add_user_to_libvirt_group () {
  EXIT_CODE=0

  echo "[···] Adding user ${USERNAME} to the group: libvirt"
  adduser "${USERNAME}" libvirt 2>/dev/null || EXIT_CODE=$?

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

# Install Cockpit as GUI to review
function install_cockpit () {
  EXIT_CODE=0

  echo "[···] Installing Cockpit"
  apt-get --quiet --assume-yes install \
    cockpit \
    cockpit-machines 2>/dev/null || EXIT_CODE=$?

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

echo "[···] Installing dependencies for the user: $USERNAME"
check_kvm
update_packages_list
install_virtualization_packages
add_user_to_libvirt_group
install_cockpit