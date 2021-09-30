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

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
data "template_file" "user_data" {
  template = file("${path.module}/cloud-init/cloud_init.cfg")
}
data "template_file" "network_config" {
  template = file("${path.module}/cloud-init/network_config.cfg")
}
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.kube_pool.name
}


resource "libvirt_volume" "kube_disk" {
  for_each = local.instances

  name = join("", [each.key, ".qcow2"])
  base_volume_id = libvirt_volume.os_image.id
  pool = libvirt_pool.kube_pool.name

  # 10GB as bytes
  size = 10000000000
}
