# Create the machine
resource "libvirt_domain" "kube_vm" {

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      network_interface["bridge"],
    ]
  }


  for_each = local.instances

  name   = each.key
  memory = each.value.memory
  vcpu   = each.value.vcpu

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id = libvirt_network.default.id
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
}

# Export a json file with current known data about the instances
locals {
  instances_data = toset([
    for vm in libvirt_domain.kube_vm : {
      name: vm.name
      mac: vm.network_interface[0].mac
    }
  ])
}
resource "local_file" "instances_data" {
  content  = jsonencode(local.instances_data)
  filename = "${path.module}/instances_data.json"
}

# Executes a script to detect instances over the network
# and fills the public IPs matching MAC addresses
resource "null_resource" "instance_data_completion" {
  triggers = {
    instance_ids = join(",", [
      for i, _ in local.instances :
        libvirt_domain.kube_vm[i].id
    ])
  }

  depends_on = [
    local_file.instances_data
  ]

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/find-instances.sh"
  }
}
