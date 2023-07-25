# WARNING: Unable the SELinux for qemu
# Ref: https://github.com/dmacvicar/terraform-provider-libvirt/issues/546
terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }

    tls = {
      source  = "hashicorp/tls"
    }
  }
}

# Configure the Libvirt provider
provider "libvirt" {
  # Use password when mode is set to 'password'. Use SSH key in other cases
  uri = var.globals.ssh_connection.mode == "password" ? (
    "qemu+ssh://${var.globals.ssh_connection.username}:${var.globals.ssh_connection.password}@${var.globals.ssh_connection.host}/system?sshauth=ssh-password&no_verify=1"
    ) : (
    "qemu+ssh://${var.globals.ssh_connection.username}@${var.globals.ssh_connection.host}/system?keyfile=${var.globals.ssh_connection.key_path}&sshauth=privkey,agent&no_verify=1"
  )
}
