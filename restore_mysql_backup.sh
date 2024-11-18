#!/bin/bash

# Load environment variables from the load-env.sh file
source ./load-env.sh

# Define variables
SERVICE_NAME="${STACK_NAME}_db"
BACKUP_FILE="$1"

# Check if a backup file was provided
if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <path_to_backup_file>"
    exit 1
fi

# Check if the backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file '$BACKUP_FILE' not found!"
    exit 1
fi

# Decompress the backup file if it is gzipped
if [[ "$BACKUP_FILE" == *.gz ]]; then
    echo "Decompressing backup file..."
    gunzip -c "$BACKUP_FILE" > /tmp/mysql_backup.sql
    BACKUP_FILE="/tmp/mysql_backup.sql"
fi

# Get the container ID for the service
CONTAINER_ID=$(docker service ps --no-trunc -q "$SERVICE_NAME" | head -n 1)

# Check if a container was found
if [ -z "$CONTAINER_ID" ]; then
    echo "Error: No running container found for service '$SERVICE_NAME'."
    exit 1
fi

# Run mysql command to restore the database using the container ID
echo "Restoring backup for container: $CONTAINER_ID"
docker exec -i "$CONTAINER_ID" /usr/bin/mysql -u root --password="$MYSQL_ROOT_PASSWORD" < "$BACKUP_FILE"

# Check if the restore command was successful
if [ $? -eq 0 ]; then
    echo "Database restored successfully from '$BACKUP_FILE'."
    # Clean up the temporary SQL file if it was created
    if [ -f /tmp/mysql_backup.sql ]; then
        rm /tmp/mysql_backup.sql
    fi
else
    echo "Error: Restore failed!"
    exit 1
fi

# chmod +x restore_mysql_backup.sh
# ./restore_mysql_backup.sh <path_to_backup_file>
