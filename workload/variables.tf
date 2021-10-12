# IP address to connect to the host
variable "SSH_HOST" {
  type = string
  description = "The IP of the SSH host to connect to"
}

# Username to be authenticated in the host
variable "SSH_USERNAME" {
  type = string
  description = "The username to be authenticated in the SSH host"
}

# Path to the private key to be authenticated in the host
# This key is provisioned by the bootstrapping step
variable "SSH_PRIVATE_KEY_PATH" {
  type = string
  description = "The path to the private key that is authorized in the SSH host"
}
