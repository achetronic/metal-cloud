# Perform dependencies installation on the metal server
resource "null_resource" "install_dependencies" {
  provisioner "file" {
    source      = "${path.module}/../scripts/install-dependencies.sh"
    destination = "/tmp/install-dependencies.sh"

    connection {
      type        = "ssh"
      host        = "${var.metal_connection.host}"
      private_key = file("${var.metal_connection.sshKeyPath}")
      user        = "${var.metal_connection.user}"
      password    = "${var.metal_connection.password}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-dependencies.sh",
      "echo ${var.metal_connection.password} | sudo -S bash /tmp/install-dependencies.sh ${var.metal_connection.user}",
    ]

    connection {
      type        = "ssh"
      host        = "${var.metal_connection.host}"
      private_key = file("${var.metal_connection.sshKeyPath}")
      user        = "${var.metal_connection.user}"
      password    = "${var.metal_connection.password}"
    }
  }

  provisioner "local-exec" {
    command = "echo ${var.metal_connection.password} | ssh-copy-id -f ${var.metal_connection.user}@${var.metal_connection.host}"
  }


}