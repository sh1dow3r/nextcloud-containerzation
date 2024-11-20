
# Nextcloud Containerization Project

This project simplifies the deployment of Nextcloud using Docker containers with a secure and scalable setup. The configuration includes a database, Redis caching, Nginx reverse proxy, and Let's Encrypt integration for SSL certificates.

---

## Features
- **Dockerized Nextcloud**: Deploy Nextcloud using pre-configured Docker Compose.
- **MariaDB Database**: Backend database support for Nextcloud.
- **Redis Cache**: Improves Nextcloud performance by caching frequently accessed data.
- **Nginx Proxy**: Acts as a reverse proxy with IPv6 support.
- **Let's Encrypt SSL**: Automatically generate and renew SSL certificates.
- **Customizable Configuration**: Environment variables for flexible domain, database, and email setup.

---

## Prerequisites
- Docker and Docker Compose installed on your system.
- A domain name (e.g., `layer0.xyz`) pointing to your server's IP.
- Ports 80 and 443 open for HTTP/HTTPS traffic.

---

## Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/sh1dow3r/nextcloud-containerzation.git
cd nextcloud-containerzation
```

### 2. Set Up Environment Variables
Create a `.env` file in the root directory:
```bash
# Database Configuration
MYSQL_ROOT_PASSWORD=Password@123
MYSQL_DATABASE=nextcloud
MYSQL_USER=nextcloud
MYSQL_PASSWORD=Password@123

# Domain and Email Configuration
DOMAIN=layer0.xyz
EMAIL=admin@layer0.xyz
```

### 3. Run the Setup Script
Run the provided bash script to set up the environment:
```bash
./setup.sh
```

This script performs the following:
- Creates the required directory structure.
- Generates `docker-compose.yml`, `nginx.conf`, and `letsencrypt.env` files.
- Initializes and starts the containers.

---

## Directory Structure
The following directories are created for mounting persistent data:
- `config`: Configuration files for Nextcloud.
- `custom_apps`: Custom Nextcloud apps.
- `data`: Nextcloud user data.
- `themes`: Custom themes for Nextcloud.
- `certs`: SSL certificates for HTTPS.
- `nginx`: Nginx configuration files.

---

## Access Nextcloud
1. Visit your domain (e.g., `https://layer0.xyz`) in a web browser.
2. Complete the Nextcloud setup wizard.

---

## Managing the Containers
Use Docker Compose commands for container management:
- **Start Services**: `docker-compose up -d`
- **Stop Services**: `docker-compose down`
- **View Logs**: `docker-compose logs`

---

## Customization
Modify the following files as needed:
- `.env`: Update domain, email, and database credentials.
- `nginx.conf`: Customize Nginx proxy settings.
- `docker-compose.yml`: Adjust service configurations or add new services.

---

## Troubleshooting
1. **Containers Fail to Start**:
   - Ensure Docker is installed and running.
   - Check `.env` for correct variable values.

2. **Domain Not Accessible**:
   - Verify DNS settings for your domain.
   - Ensure ports 80 and 443 are open.

3. **SSL Issues**:
   - Check logs for `letsencrypt-nginx-proxy-companion`.
   - Verify your domain resolves to the server IP.

---

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

