terraform {
  before_hook "transfer_public_key" {
    commands     = ["apply", "plan"]
    execute      = [
      "bash",
      "./scripts/transfer-public-key.sh",
      "192.168.0.119",
      "slimbook",
      "slimbook"
    ]
  }

  before_hook "transfer_installation_script" {
    commands     = ["apply", "plan"]
    execute      = [
      "bash",
      "./scripts/transfer-installation-script.sh",
      "192.168.0.119",
      "slimbook",
      "~/.ssh/id_ed25519"
    ]
  }

  before_hook "execute_installation_script" {
    commands     = ["apply", "plan"]
    execute      = [
      "bash",
      "./scripts/execute-installation-script.sh",
      "192.168.0.119",
      "~/.ssh/id_ed25519",
      "slimbook",
      "slimbook"
    ]
  }

}

# Indicate the input values to use for the variables of the module.
inputs = {

  # Connection to the metal server
  metal_connection = {
    host = "192.168.0.119",
    user = "slimbook",
    password = "slimbook",
    sshKeyPath = "~/.ssh/id_ed25519"
  }

}