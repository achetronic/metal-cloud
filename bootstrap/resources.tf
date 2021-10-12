# Install dependencies on the host
resource "null_resource" "install_dependencies" {

  provisioner "file" {
    source      = "${path.module}/scripts/install-dependencies.sh"
    destination = "/tmp/install-dependencies.sh"

    connection {
      type        = "ssh"
      host        = "${var.SSH_HOST}"
      private_key = file("${var.SSH_PRIVATE_KEY_PATH}")
      user        = "${var.SSH_USERNAME}"
      password    = "${var.SSH_PASSWORD}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-dependencies.sh",
      "echo ${var.SSH_PASSWORD} | sudo -S bash /tmp/install-dependencies.sh ${var.SSH_USERNAME}",
    ]

    connection {
      type        = "ssh"
      host        = "${var.SSH_HOST}"
      private_key = file("${var.SSH_PRIVATE_KEY_PATH}")
      user        = "${var.SSH_USERNAME}"
      password    = "${var.SSH_PASSWORD}"
    }
  }
}

# Upload current public key to host
resource "null_resource" "upload_public_key" {
  provisioner "local-exec" {
    command = "echo ${var.SSH_PASSWORD} | ssh-copy-id -f ${var.SSH_USERNAME}@${var.SSH_HOST}"
  }
}