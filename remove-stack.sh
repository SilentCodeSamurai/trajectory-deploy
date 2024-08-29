#!/bin/bash

# Ensure environment variables are loaded
source ./load-env.sh

# Check if the required environment variables are set
if [ -z "$STACK_NAME" ]; then
    echo "STACK_NAME is not set. Please check your .env file."
    exit 1
fi

# Use the loaded environment variables
echo "Removing deployment of stack $STACK_NAME"

# Remove the stack using Docker
docker stack rm $STACK_NAME
