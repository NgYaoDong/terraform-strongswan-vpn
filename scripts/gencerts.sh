#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# num_clients=3    # Number of client directories to create
# num_gateways=1   # Number of gateway directories to create
ca_key="certs/ca/caKey.pem"  # Path to CA private key
ca_cert="certs/ca/caCert.pem"  # Path to CA certificate

# Create client directories under certs/ and generate keys, requests, and certs
for i in $(seq 1 "$num_clients"); do
    dir="certs/client$i"
    if [ ! -d "$dir" ]; then
        echo "Creating directory: $dir"
        mkdir -p "$dir"
    fi

    # Initialize paths for client key, request, and certificate
    echo "Begin generation of keys, requests, and certificates for client$i..."
    key_file="$dir/client${i}Key.pem"
    req_file="$dir/client${i}Req.pem"
    cert_file="$dir/client${i}Cert.pem"

    # Generate private key for the client
    echo "  Generating private key for client$i..."
    pki --gen --type ed25519 --outform pem > "$key_file"

    # Generate certificate request for the client
    echo "  Generating certificate request for client$i..."
    dn="C=CH, O=strongSwan, CN=client${i}.strongswan.org"
    san="client${i}.strongswan.org"
    pki --req --type priv --in "$key_file" \
        --dn "$dn" --san "$san" --outform pem > "$req_file"

    # Generate certificate for the client
    echo "  Generating certificate for client$i..."
    pki --issue --cacert $ca_cert --cakey $ca_key \
        --type pkcs10 --in "$req_file" --serial 01 --lifetime 1826 \
        --outform pem > "$cert_file"

    echo "  Copying client certificate, key and config to client${i} directory..."
    client="clients/client${i}"
    # Copy the generated key to the respective client directories
    if [ -d "$client/private" ]; then
        cp "$key_file" "$client/private/"
        echo "  Copied client${i}Key.pem to $client/private/"
    fi
    # Copy the generated certificate to the respective client directories
    if [ -d "$client/x509" ]; then
        cp "$cert_file" "$client/x509/"
        echo "  Copied client${i}Cert.pem to $client/x509/"
    fi
    # Copy the config file to the respective client directories
    config_file="misc/conf/client${i}/swanctl.conf"
    cp "$config_file" "$client/"
    echo "  Copied swanctl.conf to $client..."
done

# Create gateway directories under certs/ and generate keys, requests, and certs
for i in $(seq 1 "$num_gateways"); do
    dir="certs/gateway$i"
    if [ ! -d "$dir" ]; then
        echo "Creating directory: $dir"
        mkdir -p "$dir"
    fi
    
    # Initialize paths for gateway key, request, and certificate
    echo "Begin generation of keys, requests, and certificates for gateway$i..."
    key_file="$dir/gateway${i}Key.pem"
    req_file="$dir/gateway${i}Req.pem"
    cert_file="$dir/gateway${i}Cert.pem"

    # Generate private key for the gateway
    echo "  Generating private key for gateway$i..."
    pki --gen --type ed25519 --outform pem > "$key_file"

    # Generate certificate request for the gateway
    echo "  Generating certificate request for gateway$i..."
    dn="C=CH, O=strongSwan, CN=gateway${i}.strongswan.org"
    san="gateway${i}.strongswan.org"
    pki --req --type priv --in "$key_file" \
        --dn "$dn" --san "$san" --outform pem > "$req_file"

    # Generate certificate for the gateway
    echo "  Generating certificate for gateway$i..."
    pki --issue --cacert $ca_cert --cakey $ca_key \
        --type pkcs10 --in "$req_file" --serial 01 --lifetime 1826 \
        --outform pem > "$cert_file"

    echo "  Copying gateway certificate, key and config to gateway${i} directory..."
    gateway="gateways/gateway${i}"
    # Copy the generated key to the respective gateway directories
    if [ -d "$gateway/private" ]; then
        cp "$key_file" "$gateway/private/"
        echo "  Copied gateway${i}Key.pem to $gateway/private/"
    fi
    # Copy the generated certificate to the respective gateway directories
    if [ -d "$gateway/x509" ]; then
        cp "$cert_file" "$gateway/x509/"
        echo "  Copied gateway${i}Cert.pem to $gateway/x509/"
    fi
    # Copy the config file to the respective gateway directories
    config_file="misc/conf/gateway${i}/swanctl.conf"
    cp "$config_file" "$gateway/"
    echo "  Copied swanctl.conf to $gateway..."
done

# Print completion message
echo "Keys, requests, and certificates generated for all client and gateway directories under certs directory."
