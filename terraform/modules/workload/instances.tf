locals {

  # Merge network fields for each instance network
  # This makes a trustable list by looking for each defined network in the networks definition
  instance_networks_expanded = {
    for vm_name, vm_data in var.instances :
    vm_name => [
      for _, vm_network in vm_data.networks :
      merge(
        { network_attachment = vm_network },
        { network_info = merge(
          var.networks[vm_network.name],
          { name = vm_network.name }
          )
        },
      )
      if length(try(var.networks[vm_network.name], {})) > 0
    ]
  }

  # Group instance's networks by type for easier attachments later
  instance_networks_grouped = {
    for vm_name, vm_networks in local.instance_networks_expanded :
    vm_name => {
      nat = distinct([
        for _, vm_network in vm_networks :
        vm_network if vm_network.network_info.mode == "nat"
      ])
      macvtap = distinct([
        for _, vm_network in vm_networks :
        vm_network if vm_network.network_info.mode == "macvtap"
      ])
    }
  }
}
# Create all instances
resource "libvirt_domain" "instance" {
  for_each = var.instances

  depends_on = [
    libvirt_network.nat
  ]

  name   = each.key
  memory = each.value.memory
  vcpu   = each.value.vcpu

  cloudinit = libvirt_cloudinit_disk.cloud_init[each.key].id

  # Attach NAT networks
  dynamic "network_interface" {
    for_each = local.instance_networks_grouped[each.key].nat

    iterator = network
    content {
      network_id = libvirt_network.nat[network.value["network_attachment"]["name"]].id
      hostname   = each.key
      # Guest VM's virtualized network interface will claim the requested IP to the virtual NAT on the Host
      # On the system level, the interface in Linux is configured in DHCP mode by using cloud-init
      # WARNING: Addresses not in CIDR notation here
      addresses      = [split("/", network.value["network_attachment"]["address"])[0]]
      wait_for_lease = true
    }
  }

  # Attach MACVTAP networks
  dynamic "network_interface" {
    for_each = local.instance_networks_grouped[each.key].macvtap

    iterator = network
    content {
      macvtap  = network.value["network_info"]["interface"]
      hostname = each.key
      # Guest virtualized network interface is connected directly to a physical device on the Host,
      # As a result, requested IP address can only be claimed by the OS: Linux is configured in static mode by cloud-init
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
  autostart  = true
}
