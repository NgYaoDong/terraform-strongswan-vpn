#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Print message indicating the start of cleanup
echo "Cleaning up client, gateway and certs directories..."

# Remove all client*, gateway* and certs directories
for dir in client*/ gateway*/ certs/; do
    if [ -d "$dir" ]; then
        echo "Removing directory: $dir"
        rm -rf "$dir"
    fi
done

# Print completion message
echo "Client, gateway and certs directories have been removed."
