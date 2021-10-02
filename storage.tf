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

# CloudInit volume to perform changes at runtime: add our ssh-key to the instance and more
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
resource "random_password" "instance_password" {
  for_each = local.instances

  length           = 16
  special          = false
  override_special = "_%@"
}
data "template_file" "user_data" {

  depends_on = [
    random_password.instance_password
  ]

  for_each = local.instances

  template = file("${path.module}/cloud-init/user_data.cfg")
  vars = {
    hostname = each.key
    user = "ubuntu"
    password = random_password.instance_password[each.key].result
  }
}
data "template_file" "network_config" {
  template = file("${path.module}/cloud-init/network_config.cfg")
}
resource "libvirt_cloudinit_disk" "cloud_init" {
  for_each = local.instances

  name           = join("", ["cloud-init-", each.key, ".iso"])
  user_data      = data.template_file.user_data[each.key].rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.kube_pool.name
}

# General purpose volume
resource "libvirt_volume" "kube_disk" {
  for_each = local.instances

  name = join("", [each.key, ".qcow2"])
  base_volume_id = libvirt_volume.os_image.id
  pool = libvirt_pool.kube_pool.name

  # 10GB as bytes
  size = 10000000000
}
