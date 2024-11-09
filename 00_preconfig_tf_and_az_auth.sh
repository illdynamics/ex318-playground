#!/bin/bash
#
# Script to preconfigure Terraform and Azure authentication

# Detect OS
OS="$(egrep ^ID /etc/os-release |cut -d'=' -f2)"

# Install Ansible, Terraform & Azure-CLI
echo "Operating System detected: ${OS}"
case $OS in
  fedora)
    sudo dnf update && sudo dnf install -y ansible terraform azure-cli
    ;;
  centos | redhat)
    sudo yum update && sudo yum install -y ansible terraform azure-cli
    ;;
  ubuntu | debian)
    sudo apt update && sudo apt install -y ansible terraform azure-cli
    ;;
  *)
    echo "OS not properly detected or unknown/unsupported for these scripts."
    ;;
esac

# Login to Terraform
terraform login

# Login to Azure CLI
az login

# Create .env file to add Azure authentication vars to
touch .env || echo "Error creating .env file for writing Azure authentication env vars to!"

# Get Azure subscription_id and add it to .env
echo "Azure subscription_id:"
az account list |grep id |cut -d'"' -f4 |tee .env && echo "Successfully added Azure subscription_id to .env"
echo "Configuring Azure CLI to use this subscription..."

# Create azure subscription_id var
ARM_SUBSCRIPTION_ID="$(head -1 .env)"

# Set Azure CLI to use the subscription_id
az account set --subscription="${ARM_SUBSCRIPTION_ID}" && echo "Successfully configured Azure CLI to use the subscription id"

# Get Azure client_id, client_secret and tenant_id and add them to .env
echo "Azure client_id, client_secret and tenant_id:"
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${ARM_SUBSCRIPTION_ID}" |egrep 'appId|password|tenant' |cut -d'"' -f4 |tee -a .env && echo "Successfully created Azure Service Principal for authentication" && echo "Successfully added Azure client_id, client_secret and tenant_id to .env"

# Create Azure client_id, client_secret and tenant_id vars
ARM_CLIENT_ID="$(tail -3 .env |head -1)"
ARM_CLIENT_SECRET="$(tail -2 .env |head -1)"
ARM_TENANT_ID="$(tail -1 .env)"

# Export the Azure authentication vars
export ARM_SUBSCRIPTION_ID="${ARM_SUBSCRIPTION_ID}"
export ARM_CLIENT_ID="${ARM_CLIENT_ID}"
export ARM_CLIENT_SECRET="${ARM_CLIENT_SECRET}"
export ARM_TENANT_ID="${ARM_TENANT_ID}"

# Add export commands to .env so we can include them later when using Terraform
echo "export ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID}" |tee -a .env
echo "export ARM_CLIENT_ID=${ARM_CLIENT_ID}" |tee -a .env
echo "export ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET}" |tee -a .env
echo "export ARM_TENANT_ID=${ARM_TENANT_ID}" |tee -a .env

# And remove the first 4 lines so we only have the 4 export statements in .env
tail -4 .env > .env

# Notification
echo "Successfully configured Azure authentication and saved the authentication config in .env to include in the Shellscripts that initiate Terraform"
