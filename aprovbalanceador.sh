#!/bin/bash
set -e
apt update -y
apt install -y apache2
# Habilitar módulos necesarios para balancear
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_balancer
a2enmod lbmethod_byrequests

cat > /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>
    ServerAdmin admin@example.com

    ProxyPreserveHost On

    <Proxy "balancer://wpcluster">
        BalancerMember http://10.0.2.10
        BalancerMember http://10.0.2.11
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass "/" "balancer://wpcluster/"
    ProxyPassReverse "/" "balancer://wpcluster/"

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

systemctl restart apache2
echo "Balanceador Apache2 configurado correctamente"
