# Map of instances' complete information
locals {
  instances_output = {
    for i, v in local.instances:
      i => merge(v, {
        hostname = i
        user = "ubuntu"
        password = random_string.instance_password[i].result
        ssh-keys = local.instances_ssh_keys
      })
  }
}
output "instances" {
  value = local.instances_output
}
