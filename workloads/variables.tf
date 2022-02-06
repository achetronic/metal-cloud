# IP address to connect to the host
variable "SSH_HOST" {
  type = "string"
  description = "The IP of the SSH host to connect to"
}

# Username to be authenticated in the host
# Warning: sudo permissions required
variable "SSH_USERNAME" {
  type = "string"
  description = "The username to be authenticated in the SSH host"
}

# Password to be authenticated in the host
# This variable is only used to bootstrap everything
variable "SSH_PASSWORD" {
  type = "string"
  description = "The password to be authenticated in the SSH host"
}

# Path to the private key to be uploaded to the host
# This key will be used for API calls
variable "SSH_PRIVATE_KEY_PATH" {
  type = "string"
  description = "The path to the private key that will be authorized in the SSH host"
}

# The networks definition block
variable "networks" {
  type = "map"
  description = "Networks definition block"
}

# The instances definition block
variable "instances" {
  type = "map"
  description = "Instances definition block"
}