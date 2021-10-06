# Create the machine
resource "libvirt_domain" "kube_vm" {
  for_each = local.instances

  depends_on = [
    #libvirt_network.kube_nat
  ]

  name   = each.key
  memory = each.value.memory
  vcpu   = each.value.vcpu

  cloudinit = libvirt_cloudinit_disk.cloud_init[each.key].id

  # Uncomment this to use a NAT
  #network_interface {
  #  network_id = libvirt_network.kube_nat.id
  #  hostname = each.key
  #  addresses = [each.value.address]
  #  wait_for_lease = true
  #}

  # Uncomment this to use host VLAN interfaces
  # DISCLAIMER: You need to create one per VM
  network_interface {
    macvtap = "eno1"
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
