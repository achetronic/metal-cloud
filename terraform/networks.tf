# Get only NAT networks
locals {
  networks_nat = tomap({
    for i, v in var.networks :
    i => v if v.mode == "nat"
  })
}
# Create all NAT networks
# Ref: https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/domain#handling-network-interfaces
resource "libvirt_network" "nat" {
  for_each = local.networks_nat

  name   = each.key
  mode   = "nat"
  bridge = each.key
  domain = join(".", [each.key, "local"])

  autostart = true
  addresses = each.value.dhcp_address_blocks

  dhcp { enabled = false }

  dns {
    enabled    = true
    local_only = false
  }
}
