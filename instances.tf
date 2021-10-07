# [join(",", [for _, v in local.instances[each.key].addresses: split("/", v)[0]] )]
# Create the machine
resource "libvirt_domain" "kube_vm" {
  for_each = local.instances

  depends_on = [
    libvirt_network.kube_nat
  ]

  name   = each.key
  memory = each.value.memory
  vcpu   = each.value.vcpu

  cloudinit = libvirt_cloudinit_disk.cloud_init[each.key].id

  dynamic "network_interface" {
    for_each = lower(local.networks.mode) == "nat" ? [1] : []
    content {
      network_id = libvirt_network.kube_nat[0].id
      hostname = each.key
      addresses = [for i, v in each.value.addresses: split("/", v)[0]]
      #wait_for_lease = true
    }
  }

  dynamic "network_interface" {
    for_each = lower(local.networks.mode) == "macvtap" ? [1] : []
    content {
      macvtap = local.networks.macvtap.interface
      hostname = each.key
    }
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
    volume_id = libvirt_volume.kube_disk[each.key].id
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }

  qemu_agent = true
  autostart = true
}
