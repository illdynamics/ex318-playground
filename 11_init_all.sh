#!/bin/bash
#
# Startup script to run the whole stack using Terraform and Ansible

# Load environment vars
source .env

DIR_TF="tf"
DIR_ANSIBLE="ansible"

# Initialize Terraform
terraform -chdir="${DIR_TF}" init

# Terraform Plan (not needed all the time)
terraform -chdir="${DIR_TF}" plan

# Apply Terraform configuration
terraform -chdir="${DIR_TF}" apply -auto-approve

# Again for public ip addresses...
terraform -chdir="${DIR_TF}" apply -auto-approve

# Generate the Ansible inventory file
terraform -chdir="${DIR_TF}" output -raw ansible_inventory > ${DIR_ANSIBLE}/files/inventory.yml

# Generate the hosts file
terraform -chdir="${DIR_TF}" output -raw hosts_file > ${DIR_ANSIBLE}/files/hosts

# Change to Ansible workdir
cd ${DIR_ANSIBLE}

# Prepare all hosts for ovirt setup
ansible-playbook -vv 01_setup_ovirt_prerequisites.yml

# Install all oVirt engines
ansible-playbook -vv 02_install_ovirt_engines.yml

# Configure all oVirt engines
ansible-playbook -vv 03_config_ovirt_engines.yml

# Install all oVirt hosts
ansible-playbook -vv 04_install_ovirt_hosts.yml

# Configure all oVirt hosts
ansible-playbook -vv 05_config_ovirt_hosts.yml
