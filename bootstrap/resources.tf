# Install dependencies on the host
resource "null_resource" "install_dependencies" {

  provisioner "file" {
    source      = "${path.module}/scripts/install-dependencies.sh"
    destination = "/tmp/install-dependencies.sh"

    connection {
      type        = "ssh"
      host        = "${var.ssh_connection.host}"
      private_key = file("${var.ssh_connection.sshKeyPath}")
      user        = "${var.ssh_connection.user}"
      password    = "${var.ssh_connection.password}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-dependencies.sh",
      "echo ${var.ssh_connection.password} | sudo -S bash /tmp/install-dependencies.sh ${var.ssh_connection.user}",
    ]

    connection {
      type        = "ssh"
      host        = "${var.ssh_connection.host}"
      private_key = file("${var.ssh_connection.sshKeyPath}")
      user        = "${var.ssh_connection.user}"
      password    = "${var.ssh_connection.password}"
    }
  }
}

# Upload current public key to host
resource "null_resource" "upload_public_key" {
  provisioner "local-exec" {
    command = "echo ${var.ssh_connection.password} | ssh-copy-id -f ${var.ssh_connection.user}@${var.ssh_connection.host}"
  }
}