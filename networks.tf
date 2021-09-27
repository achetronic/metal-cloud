# Create a virtual-bridge to connect to the real bridge interface
resource "libvirt_network" "default" {
  name = "default"
  mode = "bridge"
  bridge = "bridge0"

  dhcp { enabled = true }

  dns {
    enabled = true
    local_only = false
    hosts {
       hostname = "gateway"
       ip = "192.168.0.1"
    }
  }
}
