#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

# Start up charon daemon
ipsec start
echo "Waiting 1s for IPsec to start..."
sleep 1

# Load all configuration files
swanctl --load-all

# If this is a client instance, initiate the 'home' child
if [ "$ROLE" = "client" ]; then
  echo "ROLE=client -- initiating home child"
  sleep 3
  swanctl --initiate --child home
else
  echo "ROLE=$ROLE -- skipping initiate"
fi

# Keep the container running
tail -f /dev/null
