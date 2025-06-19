#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Number of client and gateway directories to generate
# num_clients=3    # Number of client directories to create
# num_gateways=1    # Number of gateway directories to create

# Subdirectories to create within each parent directory
subdirs=("bliss" "ecdsa" "pkcs12" "pkcs8" "private" "pubkey" "rsa" "x509" "x509aa" "x509ac" "x509ca" "x509crl" "x509ocsp")

# Create main directories for clients and gateways
echo "Creating main directories..."
mkdir -p clients
echo "  Created main directory: clients"
mkdir -p gateways
echo "  Created main directory: gateways"

# Loop through each parent client directory
for i in $(seq 1 "$num_clients"); do
    parent="clients/client$i"  # Name of the client directory (e.g., clients/client1)
    echo "Creating parent directory: $parent"
    mkdir -p "$parent"  # Create the client directory if it doesn't exist

    # Loop through each subdirectory and create it under the parent
    for sub in "${subdirs[@]}"; do
        mkdir -p "$parent/$sub"  # Create the subdirectory inside the client directory
        echo "  Created subdirectory: $parent/$sub"
    done
    
done

# Loop through each parent gateway directory
for i in $(seq 1 "$num_gateways"); do
    parent="gateways/gateway$i"  # Name of the gateway directory (e.g., gateways/gateway1)
    echo "Creating parent directory: $parent"
    mkdir -p "$parent"  # Create the gateway directory if it doesn't exist

    # Loop through each subdirectory and create it under the parent
    for sub in "${subdirs[@]}"; do
        mkdir -p "$parent/$sub"  # Create the subdirectory inside the gateway directory
        echo "  Created subdirectory: $parent/$sub"
    done

done

# Print completion message
echo "Directory generation complete."
echo "Created $num_clients client directories and $num_gateways gateway directories."
