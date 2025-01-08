#!/bin/bash

# save_mysql_backup.sh

# Load environment variables from .env file
set -o allexport
source .env
set +o allexport

log() {
    echo "$TIMESTAMP - $1"
}

# Define the timestamp
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')

# Get values from environment variables or set default
MYSQL_BACKUP_FOLDER=${MYSQL_BACKUP_FOLDER:-"/root/mysql_backups"}
MYSQL_BACKUP_EMAIL_TO=${MYSQL_BACKUP_EMAIL_TO:-""}  # Default to empty if not set

# Define the backup file
BACKUP_FILE="${MYSQL_BACKUP_FOLDER}/backup_${TIMESTAMP}.sql.gz"

# Email settings
EMAIL_SUBJECT="MySQL Backup - ${TIMESTAMP}"
EMAIL_BODY="Please find the attached MySQL backup file."

# Run the create_mysql_backup.sh script with the backup folder as an argument
log "Starting MySQL backup process."
if ./create_mysql_backup.sh "$BACKUP_FILE"; then
    log "MySQL backup completed successfully."
    
    # Check if email is set before sending
    if [[ -n "$MYSQL_BACKUP_EMAIL_TO" ]]; then
        if echo "$EMAIL_BODY" | mail -s "$EMAIL_SUBJECT" -A "$BACKUP_FILE" "$MYSQL_BACKUP_EMAIL_TO"; then
            log "Backup file sent to $MYSQL_BACKUP_EMAIL_TO."
        else
            log "Failed to send backup file to $MYSQL_BACKUP_EMAIL_TO."
        fi
    else
        log "No email recipient specified. Skipping email notification."
    fi
else
    log "MySQL backup failed."
    exit 1
fi

# chmod +x save_mysql_backup.sh
# crontab -e
# 0 */12 * * * /path/to/save_mysql_backup.sh >> /root/log/save_mysql_backup.log