# Trajectory deploy

Deployment of wordpress fpm nginx and react app with docker.

## Installation

Instructions:

# Clone the repository

```bash
git clone https://github.com/SilentCodeSamurai/trajectory-deploy.git
```

# Install docker and docker-compose

Installation depends on your OS. Documentation: https://docs.docker.com/install/

### Setup frontend

Place compiled react app in ./frontend/build

### Build frontend docker image

```bash
cd frontend
docker build -t trajectory-frontend .
```

### Setup plugins for wordpress

Place plugins in ./wordpress/plugins

### Create docker network

```bash
docker network create -d bridge intranet
```

### Run containers

```bash
docker-compose up
```

### Open browser

http://wp.localhost
