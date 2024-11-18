#!/bin/bash

# Load environment variables from the load-env.sh file
source ./load-env.sh

# Define variables
SERVICE_NAME="${STACK_NAME}_db"
BACKUP_FILE="/root/mysql_backups/mysql_backup_$(date +%Y%m%d_%H%M%S).sql.gz"

# Get the container ID for the service
CONTAINER_NAME=$(docker service ps -q "$SERVICE_NAME" | head -n 1)

# Check if a container was found
if [ -z "$CONTAINER_NAME" ]; then
    echo "Error: No running container found for service '$SERVICE_NAME'."
    exit 1
fi

# Run the mysqldump command to create a backup
echo "Creating backup for container: $CONTAINER_NAME"
docker exec "$CONTAINER_NAME" /usr/bin/mysqldump -u root --password="$MYSQL_ROOT_PASSWORD" --all-databases | gzip > "$BACKUP_FILE"

# Check if the backup command was successful
if [ $? -eq 0 ]; then
    echo "Backup created successfully at '$BACKUP_FILE'."
else
    echo "Error: Backup failed!"
    exit 1
fi

# chmod +x create_mysql_backup.sh
# ./create_mysql_backup.sh
