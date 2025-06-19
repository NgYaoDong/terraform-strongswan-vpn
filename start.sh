#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Menu for managing the VPN network with Terraform

echo "==== VPN Network Menu ===="
echo "1) Spin up the VPN network"
echo "2) Tear Down the VPN network"
echo "3) Exit"
echo "====================================="
echo -n "Enter your choice [1-3]: "
read -r menu_choice

case "$menu_choice" in
    1)
        echo "Spinning up the VPN network..."
        set -a # Automatically export all variables defined in the script
        read -p "Enter the number of clients to create: " num_clients
        read -p "Enter the number of gateways to create: " num_gateways
        set +a # Stop automatically exporting variables
        
        # Writing the number of clients and gateways to custom.auto.tfvars
        echo "Setting up custom.auto.tfvars with the number of clients and gateways..."
        echo "num_clients = $num_clients" > custom.auto.tfvars
        echo "num_gateways = $num_gateways" >> custom.auto.tfvars
        
        # Setting the working directory to the scripts directory
        dir="scripts/"
        
        # Initialisation steps (directory and cert generation)
        echo "Initialising directory structure and generating CA key and certificate..."
        bash "$dir/gendir.sh"
        echo "Directory structure initialized."
        
        echo "Generating CA key and certificate..."
        bash "$dir/genca.sh"
        echo "CA key and certificate generated."
        
        echo "Generating client and gateway certificates..."
        bash "$dir/gencerts.sh"
        echo "Client and gateway certificates generated."
        
        echo "Initialisation complete. All $num_clients client and $num_gateways gateway directories are set up with certificates within them."
        
        echo "Do you want to clean up the cert directories? ([y]es/[n]o)"
        read -r response
        if [[ "$response" == "yes" || -z "$response" || "$response" == "y" ]]; then
            echo "Cleaning up directories..."
            rm -rf certs/
            echo "Directories cleaned up."
        else
            echo "Directories retained. You can find the certificates in the certs/ directory."
        fi

        # Spinning up the VPN network with Terraform
        echo "Spinning up the VPN network with Terraform..."
        # Initialize and apply Terraform configuration
        terraform init
        terraform apply -auto-approve -var-file=custom.auto.tfvars
        echo "VPN network spun up."
    ;;
    2)
        echo "Spinning down the VPN network..."
        terraform destroy -auto-approve -var-file=custom.auto.tfvars

        echo "Do you want to clean up the client and gateway directories? ([y]es/[n]o)"
        read -r response
        if [[ "$response" == "yes" || -z "$response" || "$response" == "y" ]]; then
            echo "Cleaning up client and gateway directories..."
            bash scripts/cleandir.sh
            echo "Client and gateway directories cleaned up."
        else
            echo "Client and gateway directories retained."
        fi
        echo "VPN network destroyed."
    ;;
    *)
        echo "Exiting. No changes made to the VPN network."
    ;;
esac
