# Metal Cloud

## Introduction
This package can be used for creating VMs (and their resources, included networks) on a bare metal Linux,
using Terraform on top of Libvirt, QEMU and KVM.

## Requirements
The project was done using as few requirements as possible. At the same time, it is divided in two scopes.
The fist one is about how to bootstrap the things needed on the hypervisors to allow the second scope ask resources
to that hosts. For that reason, the following CLIs are required:

- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (> v2.12.2)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform) (> v1.0.0)

## Why changed the approach
Previously, this project was coded using only Terraform for both scopes (bootstrap and workloads), using a little bash 
script executed for the bootstrap stage too. This was an error due to Terraform was designed to call providers' APIs and, 
in that first stage, the tools to have an API are being installed. The packages to install depends on the OS, and Ansible
is better for that task. It seems obvious that the change was needed to allow improvements in the near future.

## How to use
1. 
```bash
todo
```


## Security considerations
For security reasons, a random password and an SSH key-pair are auto-generated per instance.
This means that each instance has a different password and a different authorized SSH key.
They are stored in the `tfstate` so execute a `terraform state list` and then show the resource you need
by using `terraform state show ···`

When the `terraform apply` is complete, all the SSH private key files are exported to the `files/output` directory 
in order to allow you to access or manage them.

There is a special directory located in `files/input/external-ssh-keys`. 
This was created for the special case that several well-known SSH keys must be authorized 
in all the instances at the same time.
This can be risky and must be used under your own responsibility. If you need it, place some `.pub` key files
inside, and they will be directly configured and authorized in all the instances.