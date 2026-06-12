#!/bin/bash
set -euo pipefail

DB_NAME="wordpress"
DB_USER="wordpress_user"
DB_PASS="CHANGE_ME_STRONG_PASSWORD"

sudo dnf update -y

# Enable CRB and install EPEL for CentOS Stream 9
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --set-enabled crb

sudo dnf install -y \
  https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
  https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm

# Install Remi repo for recent PHP
sudo dnf install -y dnf-utils
sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm

sudo dnf module reset php -y
sudo dnf module enable php:remi-8.3 -y

# Install Apache, MariaDB, PHP and tools
sudo dnf install -y \
  httpd mariadb-server \
  php php-cli php-mysqlnd php-gd php-xml php-mbstring php-curl php-zip php-json php-opcache \
  unzip wget tar rsync policycoreutils-python-utils

sudo systemctl enable --now httpd mariadb

# Firewall
if systemctl is-active --quiet firewalld; then
  sudo firewall-cmd --permanent --add-service=http
  sudo firewall-cmd --permanent --add-service=https
  sudo firewall-cmd --reload
fi

# Create WordPress database and user
sudo mysql <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Download and install WordPress
cd /tmp
wget -O latest.tar.gz https://wordpress.org/latest.tar.gz
tar xzf latest.tar.gz

sudo rsync -av --delete wordpress/ /var/www/html/

sudo chown -R apache:apache /var/www/html
sudo find /var/www/html -type d -exec chmod 755 {} \;
sudo find /var/www/html -type f -exec chmod 644 {} \;

# Apache config for WordPress permalinks / .htaccess
sudo tee /etc/httpd/conf.d/wordpress.conf >/dev/null <<'EOF'
<Directory /var/www/html>
    AllowOverride All
    Require all granted
</Directory>
EOF

# SELinux contexts
sudo semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html(/.*)?"
sudo restorecon -Rv /var/www/html

sudo systemctl restart httpd

echo "Done. Open: http://your-server-ip/"
echo "Database: ${DB_NAME}"
echo "User: ${DB_USER}"
echo "Password: ${DB_PASS}"