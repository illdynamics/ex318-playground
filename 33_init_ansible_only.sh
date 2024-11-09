#!/bin/bash
#
# Config script to run only the Ansible part of the stack

DIR_TF="tf"
DIR_ANSIBLE="ansible"

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

