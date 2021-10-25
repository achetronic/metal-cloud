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
terraform init && terraform apply --target module.init
```


3. Declare all VMs to create.
> Change the file called `data.tf`.
> Several examples can be found inside (yes, for Kubernetes)


4. Create your VMs.
```bash
terraform apply --target module.workload
```

## Security considerations
For security reasons, a random password and an SSH key-pair are auto-generated per instance.
This means that each instance has a different password and a different authorized SSH key.
They are stored in the `tfstate` so execute a `terraform state list` and then show the resource you need
by using `terraform state show ···`

When the `terraform apply` is complete, all the SSH private key files are exported in order 
to allow you to access or manage them.

There is a special directory located in `modules/workload/external-ssh-keys`. 
This was created for the special case that several well-known SSH keys must be authorized 
in all the instances at the same time.
This can be risky and must be used under your own responsibility. If you need it, place some `.pub` key files
inside, and they will be directly configured and authorized in all the instances.