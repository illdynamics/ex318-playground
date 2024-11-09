terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.114.0"
    }
    ansible = {
      source = "ansible/ansible"
      version = "1.3.0"
    }
    ovirt = {
      source = "oVirt/ovirt"
      version = "2.1.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "ansible" {
  # Configuration options
}

provider "ovirt" {
  url = var.ovirt_mgmt_url
  username = var.ovirt_username
  password = var.adm_password
  tls_ca_files = var.tls_ca_files
  tls_ca_dirs = var.tls_ca_dirs
  tls_ca_bundle = var.tls_ca_bundle
  tls_system = var.tls_system
  tls_insecure = var.tls_insecure
  mock = var.mock
  extra_headers = var.extra_headers
}
