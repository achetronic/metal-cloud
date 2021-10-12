# SSH connection to bare metal server
# Warning: sudo permissions required
variable "ssh_connection" {
  type = object({
    host = string,
    user = string,
    password = string,
    sshKeyPath = string
  })
}
