#!/bin/bash

# mysql_cli.sh

# Load environment variables from .env file
set -o allexport
source .env
set +o allexport

SERVICE_NAME="${STACK_NAME}_db"

# Get the task ID for the service
TASK_ID=$(docker service ps --filter "desired-state=running" --format "{{.ID}}" "$SERVICE_NAME" | head -n 1)

# Check if a task was found
if [ -z "$TASK_ID" ]; then
    echo "Error: No running task found for service '$SERVICE_NAME'."
    exit 1
fi

# Get the container ID from the task ID
CONTAINER_ID=$(docker inspect --format '{{.Status.ContainerStatus.ContainerID}}' "$TASK_ID")

# Check if a container ID was found
if [ -z "$CONTAINER_ID" ]; then
    echo "Error: No container found for task ID '$TASK_ID'."
    exit 1
fi

# Connect to the MySQL container
docker exec -it "$CONTAINER_ID" -u root --password="$MYSQL_ROOT_PASSWORD" mysql

# chmod +x mysql_cli.sh
