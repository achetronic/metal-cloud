# Connection to the metal server
variable "metal_connection" {
  type = object({
    host = string,
    user = string,
    sshKeyPath = string
  })

  default = {
      host = "192.168.0.100",
      user = "root",
      sshKeyPath = "~/.ssh/id_ed25519"
  }
}
