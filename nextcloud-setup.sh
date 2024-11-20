#!/bin/bash

# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)

# Create necessary directories
mkdir -p nextcloud-docker/{config,custom_apps,data,themes,certs,nginx}

# Create docker-compose.yml
cat <<EOF > nextcloud-docker/docker-compose.yml
version: '3'

services:
  db:
    image: mariadb
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: \$MYSQL_ROOT_PASSWORD
      MYSQL_DATABASE: \$MYSQL_DATABASE
      MYSQL_USER: \$MYSQL_USER
      MYSQL_PASSWORD: \$MYSQL_PASSWORD
    volumes:
      - db:/var/lib/mysql

  app:
    image: nextcloud
    restart: always
    volumes:
      - nextcloud:/var/www/html
      - ./config:/var/www/html/config
      - ./custom_apps:/var/www/html/custom_apps
      - ./data:/var/www/html/data
      - ./themes:/var/www/html/themes
    environment:
      MYSQL_PASSWORD: \$MYSQL_PASSWORD
      MYSQL_DATABASE: \$MYSQL_DATABASE
      MYSQL_USER: \$MYSQL_USER
      MYSQL_HOST: db
      REDIS_HOST: redis
      REDIS_HOST_PORT: 6379
    depends_on:
      - db
      - redis

  redis:
    image: redis:alpine
    restart: always
    volumes:
      - redis:/data

  proxy:
    image: jwilder/nginx-proxy
    restart: always
    ports:
      - 80:80
      - 443:443
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./certs:/etc/nginx/certs
    environment:
      ENABLE_IPV6: 'true'
    depends_on:
      - app

  letsencrypt:
    image: jrcs/letsencrypt-nginx-proxy-companion
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./certs:/etc/nginx/certs
    environment:
      NGINX_PROXY_CONTAINER: proxy

volumes:
  db:
  nextcloud:
  redis:
  certs:
EOF

# Create nginx.conf
cat <<EOF > nextcloud-docker/nginx.conf
worker_processes 1;

events { worker_connections 1024; }

http {
    server {
        listen 80;
        server_name \$DOMAIN;
        location / {
            proxy_pass http://app:80;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
EOF

# Create letsencrypt.env
cat <<EOF > nextcloud-docker/letsencrypt.env
LETSENCRYPT_EMAIL=\$EMAIL
LETSENCRYPT_HOST=\$DOMAIN
EOF

# Navigate to the project directory
cd nextcloud-docker

# Start the services using Docker Compose
docker-compose up -d
