#!/bin/bash

# Core
docker pull nginx:latest
docker pull mysql:8.0
docker pull wordpress:php8.1-fpm

# Metrics
docker pull prom/prometheus:latest
docker pull grafana/grafana:latest

# Exporters
docker pull nginx/nginx-prometheus-exporter:latest
docker pull prom/mysqld-exporter
docker pull hipages/php-fpm_exporter:latest
docker pull gcr.io/cadvisor/cadvisor
