# Create the workload resources in the target host through SSH
module "arm-virtual-machines" {

  source = "git@github.com:achetronic/metal-cloud.git//terraform?ref=v1.0.0"

  # Global configuration
  globals   = local.globals

  # Configuration related to VMs directly
  networks  = local.networks
  instances = local.instances
}
