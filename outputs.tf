locals {
  # Prepare relevant information about recently modified instances
  instances_information = {
    for i, v in local.instances:
      i => merge(v, {
        hostname = i
        user = "ubuntu"
        password = random_string.instance_password[i].result
        ssh-keys = local.instances_ssh_keys
      })
  }

  # Encode output in YAML and replace all the strange symbols on the keys
  instances_information_yaml = replace(
    yamlencode(local.instances_information),
    "/((?:^|\n)[\\s-]*)\"([\\w-]+)\":/", "$1$2:"
  )
}

# Outputs all relevant information to connect to the instances
output "instances_information" {
  sensitive = true
  value = local.instances_information_yaml
}

# Outputs instances' networks complete information
output "instance_networks_expanded" {
  sensitive = true
  value = local.instance_networks_expanded
}

# Output instance networks grouped by type
output "instance_networks_grouped" {
  sensitive = true
  value = local.instance_networks_grouped
}