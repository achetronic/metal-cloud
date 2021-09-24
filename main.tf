# WARNING: Unable the SELinux for qemu
# Ref: https://github.com/dmacvicar/terraform-provider-libvirt/issues/546
terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

# Configure the Libvirt provider
provider "libvirt" {
  uri = "qemu+ssh://slimbook@192.168.0.119/system"
}


# Create a virtual-bridge to connect to the real bridge interface
resource "libvirt_network" "default" {
  name = "default"
  mode = "bridge"
  bridge = "bridge0"

  dhcp { enabled = true }

  dns {
    enabled = true
    local_only = true
    hosts {
       hostname = "gateway-1"
       ip = "192.168.0.1"
    }
  }
}


#
resource "libvirt_pool" "kube_pool" {
  name = "kube_pool"
  type = "dir"
  path = "/home/slimbook/kube_pool"
}

# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "os_image" {
  name   = "ubuntu-hirsute.qcow2"
  source = "https://cloud-images.ubuntu.com/releases/hirsute/release/ubuntu-21.04-server-cloudimg-amd64.img"
  pool   = libvirt_pool.kube_pool.name
}

resource "libvirt_volume" "kube_disk" {
  name = "kube-disk.qcow2"
  base_volume_id = libvirt_volume.os_image.id
  pool = libvirt_pool.kube_pool.name

  # 10GB as bytes
  size = 10000000000
}

# Create the machine
resource "libvirt_domain" "kube_vm" {
  name   = "kube-vm-0"
  memory = "2048"
  vcpu   = 1

  network_interface {
    network_name = libvirt_network.default.name
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.kube_disk.id
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }
}


