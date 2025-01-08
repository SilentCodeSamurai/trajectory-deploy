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
SPLIT_PREFIX="${MYSQL_BACKUP_FOLDER}/backup_${TIMESTAMP}_part_"
SPLIT_SIZE="29M"  # Maximum size of each split file

# Email settings
EMAIL_SUBJECT="MySQL Backup - ${TIMESTAMP}"
EMAIL_BODY="Please find the attached MySQL backup files."

# Run the create_mysql_backup.sh script with the backup folder as an argument
log "Starting MySQL backup process."
if ./create_mysql_backup.sh "$BACKUP_FILE"; then
    log "MySQL backup completed successfully."
    
    # Split the backup file into parts
    log "Splitting backup file into parts of size ${SPLIT_SIZE}."
    split -b "$SPLIT_SIZE" "$BACKUP_FILE" "$SPLIT_PREFIX"

    # Check if email is set before sending
    if [[ -n "$MYSQL_BACKUP_EMAIL_TO" ]]; then
        # Create a temporary file list for attachments
        ATTACHMENTS=$(ls ${SPLIT_PREFIX}* | tr '\n' ' ')

        # Send email with all split files as attachments
        if echo "$EMAIL_BODY" | mail -s "$EMAIL_SUBJECT" $ATTACHMENTS "$MYSQL_BACKUP_EMAIL_TO"; then
            log "Backup files sent to $MYSQL_BACKUP_EMAIL_TO."
        else
            log "Failed to send backup files to $MYSQL_BACKUP_EMAIL_TO."
        fi
    else
        log "No email recipient specified. Skipping email notification."
    fi
else
    log "MySQL backup failed."
    exit 1
fi

# Clean up split files after sending email
rm -f ${SPLIT_PREFIX}*

# chmod +x save_mysql_backup.sh
# crontab -e
# 0 */12 * * * /path/to/save_mysql_backup.sh >> /root/log/save_mysql_backup.log
