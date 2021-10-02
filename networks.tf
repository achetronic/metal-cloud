# Create a NAT private network
# Ref: https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/domain#handling-network-interfaces
resource "libvirt_network" "kube_network" {
  name = "kubenet"
  mode = "nat"
  domain = "k8s.local"

  addresses = ["10.17.3.0/24"]

  dhcp { enabled = true }

  dns {
    enabled = true
    local_only = false
  }
}
