# Create the workload resources in the target host through SSH
module "workload" {
  source = "./modules/workload"

  # Variables definition
  ssh_connection = {
    host             = var.SSH_HOST
    username         = var.SSH_USERNAME
    private_key_path = var.SSH_PRIVATE_KEY_PATH
  }

  networks  = local.networks
  instances = local.instances
}
