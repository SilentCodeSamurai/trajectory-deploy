# Trajectory deploy

Deployment of wordpress fpm nginx and react app with docker.

## Installation

Instructions:

# Clone the repository

```bash
git clone https://github.com/username/repository.git
```

# Install docker and docker-compose

Installation depends on your OS. Documentation: https://docs.docker.com/install/

# Create docker network

```bash
docker network create -d bridge intranet
```

# Build frontend docker image

```bash
cd frontend
docker build -t trajectory-frontend .
```

# Setup plugins for wordpress

Place plugins in ./wordpress/plugins

# Run containers

```bash
docker-compose up
```

# Open browser

http://wp.localhost
