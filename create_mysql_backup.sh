#!/bin/bash

# create_mysql_backup.sh

# Check if the backup file name argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <backup_file_name>"
    exit 1
fi

# Load environment variables from the load-env.sh file
if source ./load-env.sh ; then
    echo "Environment variables loaded successfully."
else
    echo "Error: Failed to load environment variables."
    exit 1
fi

# Define variables
BACKUP_FILE="$1"
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

# Run the mysqldump command to create a backup
echo "Creating backup for container: $CONTAINER_ID"
if docker exec "$CONTAINER_ID" /usr/bin/mysqldump -u root --password="$MYSQL_ROOT_PASSWORD" --all-databases | gzip > "$BACKUP_FILE"; then
    echo "Backup created successfully at '$BACKUP_FILE'."
else
    echo "Error: Backup failed!"
    exit 1
fi

# chmod +x create_mysql_backup.sh
# ./create_mysql_backup.sh <backup_file_name>
