#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

echo "Initializing directory structure and generating CA key and certificate..."
bash gendir.sh
echo "Directory structure initialized."

echo "Generating CA key and certificate..."
bash genca.sh
echo "CA key and certificate generated."

echo "Generating client and gateway certificates..."
bash gencerts.sh
echo "Client and gateway certificates generated."

echo "Initialization complete. All directories and certificates are set up."

echo "Do you want to clean up the cert directories? ([y]es/[n]o)"
read -r response
if [[ "$response" == "yes" || -z "$response" || "$response" == "y" ]]; then
    echo "Cleaning up directories..."
    rm -rf certs/
    echo "Directories cleaned up."
else
    echo "Directories retained. You can find the certificates in the certs/ directory."
fi
