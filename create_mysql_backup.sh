#!/bin/bash

# Load environment variables from the load-env.sh file
source ./load-env.sh

# Define variables
CONTAINER_NAME="${STACK_NAME}_db"
BACKUP_DIR="/root/mysql_backups"
DATE=$(date +"%Y%m%d%H%M")
BACKUP_FILE="$BACKUP_DIR/mysql_backup_$DATE.sql"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Run mysqldump command inside the MySQL container
echo "Starting backup for container: $CONTAINER_NAME"
docker exec "$CONTAINER_NAME" /usr/bin/mysqldump -u root --password="$MYSQL_ROOT_PASSWORD" --all-databases > "$BACKUP_FILE"

# Check if the mysqldump command was successful
if [ $? -eq 0 ]; then
    # Optional: Compress the backup
    gzip "$BACKUP_FILE"
    echo "Backup created successfully at $BACKUP_FILE.gz"
else
    echo "Error: Backup failed!"
    exit 1
fi

# chmod +x create_mysql_backup.sh
# ./create_mysql_backup.sh
