#!/bin/bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y apache2

sudo mkdir -p /var/www/site1
sudo cp -r "$(dirname "$0")/../site1/"* /var/www/site1/
sudo chown -R www-data:www-data /var/www/site1
sudo chmod -R 755 /var/www/site1

# create virtual host
SITE_CONF="/etc/apache2/sites-available/site1.conf"
sudo tee "$SITE_CONF" > /dev/null <<'EOF'
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/site1
    ErrorLog ${APACHE_LOG_DIR}/site1_error.log
    CustomLog ${APACHE_LOG_DIR}/site1_access.log combined
</VirtualHost>
EOF

# enable the new site and restart apache
sudo a2ensite site1.conf
sudo a2dissite 000-default.conf >/dev/null 2>&1 || true
sudo systemctl restart apache2

echo "Bare-metal Apache deployed successfully."
