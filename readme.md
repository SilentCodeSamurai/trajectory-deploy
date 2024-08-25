# Trajectory deploy

Deployment of wordpress fpm nginx and react app with docker.

## Installation

Instructions:

## Clone the repository

```bash
git clone https://github.com/SilentCodeSamurai/trajectory-deploy.git
```

## Setup plugins for wordpress

Place plugins in ./wordpress/plugins

## Install docker

Installation depends on your OS. Documentation: https://docs.docker.com/install/

## Setup frontend

Place compiled react app in ./frontend/build

### Build frontend docker image

```bash
cd frontend
docker build -t trajectory-frontend .
cd ..
```

## Init docker swarm

```bash
docker swarm init --advertise-addr <server_ip>
```

## Create docker network

```bash
docker network create --driver overlay --scope swarm intranet
```

## Deploy the stack

```bash
docker stack deploy -c swarm.yml trajectory
```

## Open browser

http://wp.localhost
