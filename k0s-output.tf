locals {
  # Build the hosts section for k0s cluster manifest
  k0s_hosts = [
    for i, v in local.instances_output : {
      role = length(regexall("(\\bmaster\\b)+", i)) != 0 ? "controller" : "worker"
      ssh = {
        address = split("/", v.addresses[0])[0]
        user = v.user
        port = 22
        keyPath = pathexpand("./ssh-keys/id_ed25519")

        bastion = {
          address = var.bastion_connection.address
          user = var.bastion_connection.user
          keyPath: var.bastion_connection.sshKeyPath
        }
      }
    }
  ]

  # Build the cluster manifest for k0sctl
  k0s_cluster_manifest = templatefile("${path.module}/templates/k0sctl.yaml.tpl", {
    hosts = local.k0s_hosts
  })
}
# Generates a file with the k0s cluster manifest
resource "local_file" "k0s_cluster_manifest" {
    content     = local.k0s_cluster_manifest
    filename = "${path.module}/k0sctl.yaml"
}
