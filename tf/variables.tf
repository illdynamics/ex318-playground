variable "prefix" {
  description = "The prefix used for all resources in this example"
  default     = "ovirt"
  type        = string
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
  default     = "westeurope"
  type        = string
}

variable "engine_fqdn" {
  description = "The FQDN used for the oVirt Engine"
  default     = "ovirt0.westeurope.cloudapp.azure.com"
  type        = string
}

variable "host_fqdn" {
  description = "The FQDN used for the oVirt Host"
  default     = "ovirt1.westeurope.cloudapp.azure.com"
  type        = string
}

variable "adm_username" {
  description = "Set this to your admin username, e.g. superstack"
  default     = "superstack"
  type        = string
}

variable "adm_password" {
  description = "Set this to your admin password."
  default = "Welkom01!"
  sensitive = "true"
  type = string
}

variable "environment" {
  description = "The environment in this example"
  default     = "dev"
  type        = string
}

variable "inventory_template" {
  description = "The inventory template Terraform will use to create the Ansible inventory."
  default     = "files/inventory.tpl"
  type        = string
}

variable "inventory_file" {
  description = "The Ansible inventory filename that Terraform will create."
  default     = "files/inventory.yml"
  type        = string
}

variable "hosts_template" {
  description = "The hosts template Terraform will use to create the hosts file."
  default     = "files/hosts.tpl"
  type        = string
}

variable "hosts_file" {
  description = "The hosts file filename that Terraform will create."
  default     = "files/hosts"
  type        = string
}

variable "ssh_private_key" {
  description = "Set this to your SSH private key file."
  default     = "files/.ssh/id_rsa"
  type        = string
}

variable "ssh_public_key" {
  description = "Set this to your SSH public key file."
  default     = "files/.ssh/id_rsa.pub"
  type        = string
}

variable "roles" {
  description = "The roles that a node can be in oVirt, i.e. engine and host"
  default     = ["engine", "host"]
  type        = list(string)
}

locals {
  node_roles  = zipmap(var.roles, range(length(var.roles)))
}

variable "ovirt_mgmt_url" {
  description = "Set this to your oVirt Engine URL, e.g. https://example.azurelocation.cloudapp.azure.com/ovirt-engine/api/"
  default     = "https://ovirt0.westeurope.cloudapp.azure.com/ovirt-engine/"
  type        = string
}

variable "tls_ca_files" {
  description = "Take trusted certificates from the specified files (list)."
  default     = "/etc/pki/ca-trust/source/anchors/ovirt-ca-bundle.crt"
  type        = string
}

variable "tls_ca_dirs" {
  description = "Take trusted certificates from the specified directories (list)."
  default     = "/etc/pki/ca-trust/source/anchors/"
  type        = string
}

variable "tls_ca_bundle" {
  description = "Take the trusted certificates from the provided variable. Certificates must be in PEM format"
  default     = "/etc/pki/ca-trust/source/anchors/ovirt-ca-bundle.pem"
  type        = string
}

variable "tls_system" {
  description = "Set this to true to use the system certificate storage to verify the engine certificate. Add the certificate to your trusted roots before running."
  default     = "true"
  type        = string
}

variable "tls_insecure" {
  description = "Set this to true to disable certificate verification."
  default     = "true"
  type        = string
}

variable "mock" {
  description = "Set to true if you want to run an in-memory test. In this mode all other options will be ignored."
  default     = "false"
  type        = string
}

variable "extra_headers" {
  description = "Set extra headers to add to each request"
  default     = {
    "X-Custom-Header" = "Hello world!"
  }
  type        = map
}
