# Metal Cloud

## Description

Provision VMs (and their resources, included networks) on a bare metal Linux, using Terraform on top of opensource tools
such as Libvirt, QEMU and KVM.

## Requirements

- OpenSSH `vx.x.x`
- Terraform `v1.2.5+`

## How to use

> All the following commands are executed from the root path of the repository

1. Declare environment vars with the SSH connection parameters.
   These can be declared as input vars inside a `.tfvars` file too

   ```bash
    export TF_VAR_SSH_HOST="XXX.XXX.XXX.XXX"
    export TF_VAR_SSH_USERNAME="yourUsername"
    export TF_VAR_SSH_PASSWORD="yourPassword"
    export TF_VAR_SSH_PRIVATE_KEY_PATH="~/.ssh/id_ed25519"
    ```

2. Install some REQUIRED dependencies in local machine

   > To build the ISOs we need to have installed `mkisofs`.

   ```bash
   sudo apt install mkisofs
   ```

3. Execute some REQUIRED previous scripts to bootstrap the host

   > By the moment, only recent Ubuntu versions are supported.
   > Feel free to extend the OS support by pushing your code to this repository.

   ```bash
   # Copy current SSH key into the target host
   echo ${TF_VAR_SSH_PASSWORD} | ssh-copy-id -f ${TF_VAR_SSH_USERNAME}@${TF_VAR_SSH_HOST}
   
   # Give execution permissions to the helper scripts
   chmod -R +x ./scripts
   
   # Connect to the host machine by SSH and install the dependencies using passwordless authentication 
   # (user with sudo privileges required) 
   scp ./scripts/prepare-host-ubuntu.sh ${TF_VAR_SSH_USERNAME}@${TF_VAR_SSH_HOST}:/tmp
   ssh ${TF_VAR_SSH_USERNAME}@${TF_VAR_SSH_HOST} "sudo bash ./tmp/prepare-host-ubuntu.sh ${TF_VAR_SSH_USERNAME}"
   ```

4. Configure Terraform to store the state of your infrastructure

   > We have configured S3 backend by default thinking on bare metal solutions like S3-compatible APIs provided by
   > solutions like TrueNAS, which cover the problem of storing the .tfstate using the same approach as major cloud 
   > providers
   
   ```bash
   # Set the right parameters for your S3 storage
   nano backends/config.s3.tfbackend
   
   # Init the process configuring your backend
   terraform init -backend-config=backends/config.s3.tfbackend
   ```

5. Declare resources related to VMs to create.

   > Change the file called `data.tf`.
   > Several examples can be found inside (yes, for Kubernetes)
   
6. Create your VMs.

   ```bash
   terraform apply
   ```

## Security considerations

For security reasons, a random password and an SSH key-pair are auto-generated per instance.
This means that each instance has a different password and a different authorized SSH key.
They are stored in the `tfstate` so execute a `terraform state list` and then show the resource you need
by using `terraform state show ···`

When the `terraform apply` is complete, all the SSH private key files are exported in order
to allow you to access or manage them.

There is a special directory located in `terraform/files/input/external-ssh-keys`.
This was created for the special case that several well-known SSH keys must be authorized
in all the instances at the same time.
This can be risky and must be used under your own responsibility. If you need it, place some `.pub` key files
inside, and they will be directly configured and authorized in all the instances.

## How to collaborate

TODO