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


# FULLY WORKING BRIDGE
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
/*resource "libvirt_pool" "default2" {
  name = "default2"
  type = "dir"
  path = "/home/slimbook/cloud_pool"
}*/

# We fetch the latest ubuntu release image from their mirrors
/*resource "libvirt_volume" "ubuntu" {
  name   = "ubuntu"
  pool   = libvirt_pool.default2.name
  source = "https://cloud-images.ubuntu.com/releases/hirsute/release/ubuntu-21.04-server-cloudimg-amd64.img"
  format = "qcow2"
}*/

# Create the machine
resource "libvirt_domain" "domain-ubuntu" {
  name   = "ubuntu-terraform"
  memory = "512"
  vcpu   = 1

  //kernel = "https://cloud-images.ubuntu.com/minimal/daily/hirsute/current/hirsute-minimal-cloudimg-amd64.img"

  //cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name = "default"
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

  /*disk {
    volume_id = libvirt_volume.ubuntu.id
  }*/

  disk {
    #file = "/var/lib/libvirt/images/dsfsdf.qcow2"
    url = "https://cloud-images.ubuntu.com/minimal/daily/hirsute/current/hirsute-minimal-cloudimg-amd64.img"
  }

  /*graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }*/
}

