# Perform dependencies installation on the metal server
resource "null_resource" "install_dependencies" {
  provisioner "file" {
    source      = "${path.module}/scripts/install-dependencies.sh"
    destination = "/tmp/install-dependencies.sh"

    connection {
      type     = "ssh"
      user     = "${var.metal_connection.user}"
      private_key = file("${var.metal_connection.sshKeyPath}")
      host     = "${var.metal_connection.host}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-dependencies.sh",
      "/tmp/install-dependencies.sh ${var.metal_connection.user}",
    ]

    connection {
      type     = "ssh"
      user     = "${var.metal_connection.user}"
      private_key = file("${var.metal_connection.sshKeyPath}")
      host     = "${var.metal_connection.host}"
    }
  }


}
