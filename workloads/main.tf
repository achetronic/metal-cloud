# Build resources on the host machine
module "workload" {
  source = "./modules/libvirt"

  # Variables definition
  ssh_connection = {
    host = var.SSH_HOST
    username = var.SSH_USERNAME
    private_key_path = var.SSH_PRIVATE_KEY_PATH
  }

  networks = var.networks
  instances = var.instances
}
