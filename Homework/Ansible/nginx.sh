#!/bin/bash

# Set noninteractive mode for debconf
export DEBIAN_FRONTEND=noninteractive

# Redirect all output to a log file
exec > >(tee /var/log/nginx-install.log) 2>&1

# Exit immediately if a command exits with a non-zero status
set -e

# Update package lists and install nginx without prompts
sudo apt-get update
sudo apt-get -y install nginx

# Your other provisioning steps go here

# Cleanup
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

# End of script
