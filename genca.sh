#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

# Initialize variables for CA key and certificate paths
key_file="certs/ca/caKey.pem"
cert_file="certs/ca/caCert.pem"

# Ensure certs/ca directory exists
if [ ! -d "certs/ca" ]; then
    mkdir -p certs/ca
fi

echo "Begin generation of CA key and certificate..."

# Generate CA private key
echo "Generating CA private key..."
pki --gen --type ed25519 --outform pem > $key_file

# Generate a self signed CA cert
echo "Generating self-signed CA certificate..."
# The lifetime is set to 3652 days (10 years)
pki --self --ca --lifetime 3652 --in $key_file \
           --dn "C=CH, O=strongSwan, CN=strongSwan Root CA" \
           --outform pem > $cert_file

# Copy caCert.pem into all x509ca directories under client* and gateway*
for dir in client* gateway*; do
    if [ -d "$dir/x509ca" ]; then
        cp $cert_file "$dir/x509ca/"
        echo "Copied caCert.pem to $dir/x509ca/"
    fi
done

# Print completion message
echo "CA key and certificate generated and copied to all x509ca directories."
