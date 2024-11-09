# 2node-ovirt-on-azure

2 node oVirt setup using Ansible, Terraform and Azure, where 1 node is the manager and 1 node is a hypervisor.
You will need a Terraform Cloud account and a working Azure subscription to use this.
Also, when you are done using the oVirt cluster, always be sure to destroy all resources, so you don't pay for the resources when you are nog using the cluster.

## Supported Operating Systems
Multiple distributions of Linux are supported, but only Linux:
* Fedora
* CentOS
* Red Hat Enterprise Linux
* RockyLinux
* AlmaLinux
* Ubuntu
* Debian

## Prerequisites
First, you will need a working Azure DevOps subscription. [Create an Azure DevOps account here.](https://azure.microsoft.com/en-us/products/devops/?nav=min)
For this, you will need a Microsoft account. Create a new one when prompted for it if needed.

Second you need a Terraform Cloud account. [Create a Terraform Cloud account here.](https://app.terraform.io)
Just create an account and verify your e-mail address.

That's it!

## How to use
How to use this repository to create an oVirt cluster on 2 VM's on Azure with Terraform and Ansible.

### Preconfiguring packages and authentication
Install Ansible, Terraform and Azure CLI and configure the authentication tokens to use.

This script will install ansible, terraform and azure-cli on your system.
Then it will initiate the Terraform login command to create an API token for you and save it in your home directory.
After that, it will initiate the Azure CLI login command to get your subscription_id, and use that to create a Service Principal, which is an account needed to authenticate Terraform with Azure. It will output 4 parameters (subscription_id, client_id, client_secret and tenant_id).

Don't worry, it will automatically configure the parameters for you to be used.

```bash
./00_preconfig_tf_and_az_auth.sh
```

### Build and deploy the whole stack
Build and deploy everything from scratch to a working oVirt cluster with 2 nodes including the whole infrastructure and all resources needed in Azure.

```bash
./11_init_all.sh
```

### Initialize Terraform only
Initialize only what's stated in the Terraform part, so only the infrastructure/networks, policies, Virtual Machines and configuration on Azure will be built and deployed.

```bash
./22_init_tf_only.sh
```

### Initialize Ansible only
Initialize only what's stated in the Ansible part, so only configure the already built and deployed Virtual Machines with Ansible to execute the needed configuration on the hosts, run the oVirt setup and configure oVirt on the hosts.

```bash
./33_init_ansible_only.sh
```

### Destroy the whole stack
Destroy the whole oVirt cluster and all infrastructure, configuration and hosts on Azure including all resources in Azure.

```bash
./99_destroy_all.sh
```

