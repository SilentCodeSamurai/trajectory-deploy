#!/bin/sh

# Run the Docker Compose file
docker compose -f nfs-update.docker-compose.yml up

# Wait for the container to finish (assuming it exits after the copy)
while docker ps | grep -q copier; do
    sleep 1
done

# Shut down the Docker Compose services
docker compose -f nfs-update.docker-compose.yml down
