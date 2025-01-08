#!bin/bash

# clear_mysql_backup.sh

# Load environment variables from .env file
set -o allexport
source .env
set +o allexport

MYSQL_BACKUP_DAYS_TO_KEEP=${MYSQL_BACKUP_DAYS_TO_KEEP:-30}
MYSQL_BACKUP_FOLDER=${MYSQL_BACKUP_FOLDER:-"/root/mysql_backups"}

# Delete backups older than the specified number of days
log "Deleting backups older than $MYSQL_BACKUP_DAYS_TO_KEEP days."
find "$MYSQL_BACKUP_FOLDER" -type f -name "*.sql.gz" -mtime +"$MYSQL_BACKUP_DAYS_TO_KEEP" -exec rm {} \; -exec log "Deleted backup: {}" \;

log "Backup management process completed."

exit 0

# chmod +x clear_mysql_backup.sh
# 0 0 * * * /path/to/clear_mysql_backup.sh >> /root/log/clear_mysql_backup.log
