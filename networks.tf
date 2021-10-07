# Create a NAT private network
# Ref: https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/domain#handling-network-interfaces
resource "libvirt_network" "kube_nat" {
  count = lower(local.networks.mode) == "nat" ? 1 : 0

  name = "kube_nat"
  mode = "nat"
  bridge = "nat0"
  domain = "k8s.local"

  addresses = local.networks.nat.addresses #CIDR notation

  dhcp { enabled = true }

  dns {
    enabled = true
    local_only = false
  }
}
