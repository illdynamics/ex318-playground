#!/bin/bash
#
# Destroy script to destroy the whole stack using Terraform

DIR_TF="tf"

# Terraform destroy
terraform -chdir="${DIR_TF}" destroy -auto-approve
