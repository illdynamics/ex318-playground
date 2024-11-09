#!/bin/bash
#
# Startup script to run only the Terraform part of the stack

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
