locals {
  # Prepare relevant information about recently modified instances
  instances_information = {
    for instance, v in var.instances:
      instance => merge(v, {
        hostname = instance
        user = "ubuntu"
        password = random_string.instance_password[instance].result
        ssh-keys = concat(
          [tls_private_key.instance_ssh_key[instance].public_key_openssh],
          local.instances_external_ssh_keys
        )
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
  value = local.instances_information
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