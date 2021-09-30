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


#resource "null_resource" "instance_detection" {
#  triggers = {
#    instance_ids = join(",", [
#      for i, v in local.instances :
#        libvirt_domain.kube_vm[i].id
#    ])
#  }
#
#  provisioner "local-exec" {
#    command = "sudo nmap -n -sP 192.168.0.1/24 | awk '/Nmap scan report/{printf $5;printf \" \";getline;getline;print $3;}' >> test.txt"
#  }
#}
