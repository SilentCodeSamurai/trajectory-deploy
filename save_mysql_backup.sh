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
SPLIT_SIZE="5M"  # Maximum size of each split file

# Run the create_mysql_backup.sh script with the backup folder as an argument
log "Starting MySQL backup process."
if ./create_mysql_backup.sh "$BACKUP_FILE"; then
    log "MySQL backup completed successfully."
    
    # Split the backup file into parts
    log "Splitting backup file into parts of size ${SPLIT_SIZE}."
    split -b "$SPLIT_SIZE" "$BACKUP_FILE" "$SPLIT_PREFIX"

    TOTAL_PARTS=$(ls ${SPLIT_PREFIX}* | wc -l)

    # Check if email is set before sending
    if [[ -n "$MYSQL_BACKUP_EMAIL_TO" ]]; then
        # Loop through split files and attach them as attachments
        CURRENT_PART=1
        for SPLIT_FILE in ${SPLIT_PREFIX}*; do
            EMAIL_SUBJECT="MySQL Backup Part - ${TIMESTAMP} - ${CURRENT_PART}/${TOTAL_PARTS} - ${SPLIT_FILE##*/}"
            EMAIL_BODY="Backup Part - ${TIMESTAMP} - ${CURRENT_PART}/${TOTAL_PARTS} - ${SPLIT_FILE##*/}"

            if echo "$EMAIL_BODY" | mail -s "$EMAIL_SUBJECT" -A "$SPLIT_FILE" "$MYSQL_BACKUP_EMAIL_TO"; then
                log "Backup part ${CURRENT_PART} / ${TOTAL_PARTS} sent to $MYSQL_BACKUP_EMAIL_TO."
            else
                log "Failed to send backup part to $MYSQL_BACKUP_EMAIL_TO."
            fi
            sleep 1
            CURRENT_PART=$((CURRENT_PART + 1))
        done
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
