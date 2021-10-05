# 1. Bastion SSH key
variable "bastion_connection" {
  type = object({
    address = string,
    user = string,
    sshKeyPath = string
  })

  default = {
      address = "192.168.0.119",
      user = "slimbook",
      sshKeyPath = "~/.ssh/id_ed25519"
  }
}
