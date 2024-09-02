#!/bin/bash

# Ensure environment variables are loaded
source ./load-env.sh

# Check if the required environment variables are set
if [ -z "$STACK_NAME" ]; then
    echo "STACK_NAME is not set. Please check your .env file."
    exit 1
fi

# Function to run NFS update
run_nfs_update() {
    echo "Running NFS update process..."
    ./nfs-update.sh
    if [ $? -ne 0 ]; then
        echo "NFS update failed."
        exit 1
    fi
}

run_nfs_reset() {
    echo "Running NFS reset process..."
    ./nfs-reset.sh
    if [ $? -ne 0 ]; then
        echo "NFS reset failed."
        exit 1
    fi
}

# Check if the "copy" argument is provided
if [ "$1" == "update" ]; then
    run_nfs_update
fi

# Check if the "reset" argument is provided
if [ "$1" == "reset" ]; then
    run_nfs_reset
fi

# Use the loaded environment variables
echo "Starting deployment of stack $STACK_NAME"

# Deploy the stack using Docker
docker stack deploy -c swarm.yml "$STACK_NAME" --detach=false
