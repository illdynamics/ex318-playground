# 2node-ovirt-on-azure

2 node oVirt setup using Ansible, Terraform and Azure, where 1 node is the manager and 1 node is a hypervisor.
You will need a working Azure subscription to use this. First month you get 200 dollars of free Azure credits.
Also, when you are done using the oVirt cluster, always be sure to destroy all resources, so you don't pay for the resources when you are nog using the cluster.

## Supported Operating Systems
<details> <summary> <b> Multiple distributions of Linux are supported, but only Linux!</b> </summary>
* Fedora
* CentOS
* Red Hat Enterprise Linux
* RockyLinux
* AlmaLinux
* Ubuntu
* Debian
</details>

## How to use
<summary> <b> How to use this repository to create an oVirt cluster on 2 VM's on Azure with Terraform and Ansible </b> </summary>

### Preconfiguring packages and authentication
<summary> <b> Install Ansible, Terraform and Azure CLI and configure the authentication tokens to use </b> </summary>

```bash
./00_preconfig_tf_and_az_auth.sh
```

### Build and deploy the whole stack
<summary> <b> Build and deploy everything from scratch to a working oVirt cluster with 2 nodes including the whole infrastructure and all resources needed in Azure </b> </summary>

```bash
./11_init_all.sh
```

### Initialize Terraform only
<summary> <b> Initialize only what's stated in the Terraform part, so only the infrastructure/networks, policies, Virtual Machines and configuration on Azure will be built and deployed </b> </summary>

```bash
./22_init_tf_only.sh
```

### Initialize Ansible only
<summary> <b> Initialize only what's stated in the Ansible part, so only configure the already built and deployed Virtual Machines with Ansible to execute the needed configuration on the hosts, run the oVirt setup and configure oVirt on the hosts </b> </summary>

```bash
./33_init_ansible_only.sh
```

### Destroy the whole stack
<summary> <b> Destroy the whole oVirt cluster and all infrastructure, configuration and hosts on Azure including all resources in Azure</b> </summary>

```bash
./99_destroy_all.sh
```

