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
  uri = "qemu+ssh://${var.metal_connection.user}@${var.metal_connection.host}/system"
}

