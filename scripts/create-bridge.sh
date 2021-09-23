#!/usr/bin/env bash
set -eo pipefail

# TODO: Execute script with Terragrunt
# TODO: Read arguments
# TODO: Refactor script using functions
# TODO: Look for non-used external interfaces

export BRIDGE_NAME="bridge0"
export BRIDGE_IPV4_CIDR="192.168.0.100/24"
export INTERFACE_NAME="eno1"

# GET PHYSICAL INTERFACES
#basename -a $(ls /sys/class/net/en* -d)


# CREATE THE BRIDGE
nmcli connection add type bridge ifname "${BRIDGE_NAME}" con-name "${BRIDGE_NAME}"
nmcli connection modify "${BRIDGE_NAME}" ipv4.method manual ipv4.address "${BRIDGE_IPV4_CIDR}"
nmcli connection up "${BRIDGE_NAME}"


# ATTACH EXTERNAL INTERFACE TO THE BRIDGE
nmcli connection modify "${INTERFACE_NAME}" master "${BRIDGE_NAME}"

# WARNING: Network Manager is not able to manage physical interfaces to change the master
# so we have to ask the same task to the kernel using `ip` command instead of `nmcli`
ip link set dev "${INTERFACE_NAME}" master "${BRIDGE_NAME}"


# DISABLE STP
# Ref: https://es.wikipedia.org/wiki/Spanning_tree
# Ref: https://wiki.debian.org/KVM#Between_VM_host.2C_guests_and_the_world
nmcli con modify "${BRIDGE_NAME}" bridge.stp no
