locals {

  # Instance basic definition.
  # WARNING: Other fields are autoconfigured
  instances = {

    # Define the masters
    kube-master-0 = {
      memory = 2048 #2GB
      vcpu = 2
      address = "10.17.3.10"
    }

    kube-master-1 = {
      memory = 2048 #2GB
      vcpu = 2
      address = "10.17.3.11"
    }

    # Define the workers
    kube-worker-0 = {
      memory = 2048 #2GB
      vcpu = 2
      address = "10.17.3.20"
    }
  }
}
