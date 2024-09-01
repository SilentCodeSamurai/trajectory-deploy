#!/bin/bash

# Ensure environment variables are loaded
source ./load-env.sh

# Check if the required environment variables are set
if [ -z "$STACK_NAME" ]; then
    echo "STACK_NAME is not set. Please check your .env file."
    exit 1
fi

# Function to run NFS copy
run_nfs_copy() {
    echo "Running NFS copy process..."
    ./nfs-copy.sh
    if [ $? -ne 0 ]; then
        echo "NFS copy failed."
        exit 1
    fi
}

# Check if the "copy" argument is provided
if [ "$1" == "copy" ]; then
    run_nfs_copy
fi

# Use the loaded environment variables
echo "Starting deployment of stack $STACK_NAME"

# Deploy the stack using Docker
docker stack deploy -c swarm.yml "$STACK_NAME" --detach=false
