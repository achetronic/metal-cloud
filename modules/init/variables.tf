# SSH parameters to connect to the host
variable "ssh_connection" {
  type = object({
    # IP address to connect to the host
    host = string

    # Username to be authenticated in the host
    username = string

    # Password to be authenticated in the host
    # This variable is only used to bootstrap everything
    password = string

    # Path to the private key to be authenticated in the host
    # This key should already exists on the host machine
    private_key_path = string
  })
  description = "SSH parameters to connect to the host"
}
