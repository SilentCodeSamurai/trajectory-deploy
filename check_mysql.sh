#!/bin/bash

# check_mysql.sh

# Load environment variables from .env file
set -o allexport
source /root/trajectory-deploy/.env
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

# Attempt to connect to the MySQL container
if docker exec "$CONTAINER_ID" mysql -u root --password="$MYSQL_ROOT_PASSWORD" -e "exit"; then
    echo "Login to MySQL successful."
else
    TO="glazunovgennadyanatolyevitch@yandex.ru"  # Change to the recipient's email address
    SUBJECT="ALERT ALARM TREVOGA"
    BODY="Mysql DB FAILED"
    
    # Send the email
    echo "$BODY" | mail -s "$SUBJECT" "$TO"
    exit 1
fi

# */10 * * * * /root/trajectory-deploy/check_mysql.sh
