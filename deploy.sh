#!/bin/bash

# Ensure environment variables are loaded
source ./load-env.sh

# Check if the required environment variables are set
if [ -z "$STACK_NAME" ]; then
    echo "STACK_NAME is not set. Please check your .env file."
    exit 1
fi

# Use the loaded environment variables
echo "Starting deployment of stack $STACK_NAME"

# Deploy the stack using Docker
docker stack deploy -c nfs.yml "$STACK_NAME" --detach=false
