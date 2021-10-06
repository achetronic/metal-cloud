# Create a NAT private network
# Ref: https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/domain#handling-network-interfaces
resource "libvirt_network" "kube_nat" {
  name = "kube_nat"
  mode = "nat"
  bridge = "nat0"
  domain = "k8s.local"

  addresses = ["10.10.0.0/24"] #CIDR notation

  dhcp { enabled = true }

  dns {
    enabled = true
    local_only = false
  }
}
