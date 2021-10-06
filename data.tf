locals {

  # Instance basic definition.
  # WARNING: Choose IP a address inside the right subnet
  instances = {

    # Define the masters
    kube-master-0 = {
      memory = 2048 #2GB
      vcpu = 2
      addresses = ["192.168.0.210/24"] #CIDR notation
      gateway4 = "192.168.0.1"
    }

    kube-master-1 = {
      memory = 2048 #2GB
      vcpu = 2
      addresses = ["192.168.0.211/24"] #CIDR notation
      gateway4 = "192.168.0.1"
    }

    # Define the workers
    kube-worker-0 = {
      memory = 2048 #2GB
      vcpu = 2
      addresses = ["192.168.0.220/24"] #CIDR notation
      gateway4 = "192.168.0.1"
    }

  }
}
