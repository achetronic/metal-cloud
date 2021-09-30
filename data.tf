locals {
  instances = {

    # Define the masters
    kube-master-0 = {
      memory = 1024
      vcpu = 1
    }

    # Define the workers
    kube-worker-0 = {
      memory = 2048
      vcpu = 1
    }

    kube-worker-1 = {
      memory = 512
      vcpu = 1
    }

    kube-worker-2 = {
      memory = 512
      vcpu = 1
    }


  }
}
