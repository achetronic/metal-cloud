#!/usr/bin/env bash
set -eo pipefail

# Steps are taken from official Ubuntu website
# Ref: https://ubuntu.com/server/docs/virtualization-libvirt

USERNAME=$1

# Path to the QEMU config file used by libvirt
_QEMU_CONFIG_PATH="/etc/libvirt/qemu.conf"

# Check virtualization availability
function install_cpu_checker () {
  EXIT_CODE=0

  echo "[···] Installing CPU checker"
  apt-get install cpu-checker 2>/dev/null || EXIT_CODE=$?

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
  apt-get --quiet update  || EXIT_CODE=$?

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

# Disable security_driver parameter for Qemu
# Ref: https://github.com/dmacvicar/terraform-provider-libvirt/issues/546
function disable_qemu_security_driver () {
  EXIT_CODE=0

  echo "[···] Disabling security driver for Qemu"
  sed --in-place -E s/"^#?security_driver = \".*\"$"/"security_driver = \"none\""/ "${_QEMU_CONFIG_PATH}" || EXIT_CODE=$?

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

# Restart libvirt
function restart_libvirt () {
  EXIT_CODE=0

  echo "[···] Restarting libvirt to apply all changes"
  systemctl restart libvirtd || EXIT_CODE=$?

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
install_cpu_checker
check_kvm
update_packages_list
install_virtualization_packages
add_user_to_libvirt_group
disable_qemu_security_driver
restart_libvirt
install_cockpit