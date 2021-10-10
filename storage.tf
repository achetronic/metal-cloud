# Create a dir where all the volumes will be created
resource "libvirt_pool" "volume_pool" {

  name = "volume_pool"
  type = "dir"
  path = "/home/slimbook/volume_pool"
}

# Fetch the latest ubuntu release image from their mirrors
# DISCLAIMER: Using Ubuntu/Debian because the author's obsession
resource "libvirt_volume" "os_image" {
  name   = "ubuntu-hirsute.qcow2"
  source = "https://cloud-images.ubuntu.com/releases/hirsute/release/ubuntu-21.04-server-cloudimg-amd64.img"
  pool   = libvirt_pool.volume_pool.name
}

# CloudInit volume to perform changes at runtime: add our ssh-key to the instance and more
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
resource "random_string" "instance_password" {
  for_each = local.instances

  length           = 16
  special          = false
  override_special = "_%@"
}
locals {
  # List of SSH keys allowed on instances
  instances_ssh_keys = [
    for i, v in fileset(path.module, "ssh-keys/*.pub") :
      trimspace(file("${path.module}/${v}"))
  ]

  # Parsed user-data config file for Cloud Init
  user_data = {
    for i, _ in local.instances :
      i => templatefile("${path.module}/templates/cloud-init/user_data.cfg", {
        hostname = i
        user     = "ubuntu"
        password = random_string.instance_password[i].result
        ssh-keys = local.instances_ssh_keys
      })
  }

  # Parsed network config file for Cloud Init
  network_config = {
    for vm_name, vm_data in local.instance_networks_expanded:
      vm_name => templatefile(
        "${path.module}/templates/cloud-init/network_config.cfg",
        { networks = vm_data }
      )
  }
}
# Volume for bootstrapping instances using Cloud Init
resource "libvirt_cloudinit_disk" "cloud_init" {
  for_each = local.instances

  name           = join("", ["cloud-init-", each.key, ".iso"])
  user_data      = local.user_data[each.key]
  network_config = local.network_config[each.key]
  pool           = libvirt_pool.volume_pool.name
}

# General purpose volumes for all the instances
resource "libvirt_volume" "kube_disk" {
  for_each = local.instances

  name = join("", [each.key, ".qcow2"])
  base_volume_id = libvirt_volume.os_image.id
  pool = libvirt_pool.volume_pool.name

  # 10GB (as bytes) as default
  size = try(each.value.disk, 10*1000*1000*1000)
}
