# Create the machine
resource "libvirt_domain" "kube_vm" {
  for_each = local.instances

  depends_on = [libvirt_network.kube_network]

  name   = each.key
  memory = each.value.memory
  vcpu   = each.value.vcpu

  cloudinit = libvirt_cloudinit_disk.cloud_init[each.key].id

  network_interface {
    network_id = libvirt_network.kube_network.id
    hostname = each.key
    addresses = [each.value.address]
    wait_for_lease = true
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

  qemu_agent = false
  autostart = true
}

# Export a json file with current known data about the instances
#locals {
#  instances_data = toset([
#    for vm in libvirt_domain.kube_vm : {
#      name: vm.name
#      mac: vm.network_interface[0].mac
#    }
#  ])
#}
#resource "local_file" "instances_data" {
#  content  = jsonencode(local.instances_data)
#  filename = "${path.module}/instances_data.json"
#}
