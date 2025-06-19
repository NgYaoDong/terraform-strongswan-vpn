#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Print message indicating the start of cleanup
echo "Cleaning up clients, gateways and certs directories..."

# Remove all clients, gateways and certs directories
for dir in clients/ gateways/ certs/; do
    if [ -d "$dir" ]; then
        echo "Removing directory: $dir"
        # Loop through each subdirectory and print its name before removing
        for sub in "$dir"*/; do
            if [ -d "$sub" ]; then
                echo "  Cleaning subdirectory: $sub"
            fi
        done
        rm -rf "$dir"
    fi
done

# Print completion message
echo "Clients, gateways and certs directories have been removed."
