# Create a virtual-bridge to connect to the real bridge interface
resource "libvirt_network" "default" {
  name = "default"
  mode = "bridge"
  bridge = "bridge0"

  dhcp { enabled = true }

  dns {
    enabled = true
    local_only = true
    hosts {
       hostname = "gateway-1"
       ip = "192.168.0.1"
    }
  }
}