# Metal Cloud

## Introduction
This package can be used for creating VMs (and their resources, included networks) on a bare metal Linux,
using Terraform on top of Libvirt, QEMU and KVM.

## How to use
1. Declare environment vars with the SSH connection parameters. 
These can be declared as input vars inside a `.tfvars` file too
```bash
export TF_VAR_SSH_HOST="XXX.XXX.XXX.XXX"
export TF_VAR_SSH_USERNAME="yourUsername"
export TF_VAR_SSH_PASSWORD="yourPassword"
export TF_VAR_SSH_PRIVATE_KEY_PATH="~/.ssh/id_ed25519"
```


2. Execute some REQUIRED previous scripts to bootstrap the host. 
> By the moment, only recent Ubuntu versions are supported. 
> Feel free to extend the OS support pushing your code to this repository.
```bash
terraform apply --target module.init
```


3. Declare all VMs to create.
> Change the file called `data.tf`.
> Several examples can be found inside (yes, for Kubernetes)


4. Create your VMs.
```bash
terraform apply --target module.workload
```