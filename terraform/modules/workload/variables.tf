# SSH parameters to connect to the host
variable "ssh_connection" {
  type = object({
    # IP address to connect to the host
    host = string

    # Username to be authenticated in the host
    username = string

    # Path to the private key to be authenticated in the host
    # This key should already exists on the host machine
    private_key_path = string
  })
  description = "SSH parameters to connect to the host"
}

# The networks definition block is the place to define
# which networks of type NAT or macvtap will be created and attachable
variable "networks" {
  type = map(object({
    mode                = string
    dhcp_address_blocks = list(string)
    gateway_address     = string
    interface           = string
  }))
  description = "Networks definition block"
}

# The instances block is the place to define all the VMs
# (and their resources) that will be created
variable "instances" {
  type = map(object({
    vcpu   = number
    memory = number
    disk   = number
    networks = list(object({
      name    = string
      address = string
    }))
  }))
  description = "Instances definition block"
}