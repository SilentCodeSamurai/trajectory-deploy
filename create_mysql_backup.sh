#!/bin/bash

# create_mysql_backup.sh

# Load environment variables from the load-env.sh file
source ./load-env.sh

# Define variables
SERVICE_NAME="${STACK_NAME}_db"
BACKUP_FILE="/root/mysql_backups/mysql_backup_$(date +%Y%m%d_%H%M%S).sql.gz"

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
# ./create_mysql_backup.sh
