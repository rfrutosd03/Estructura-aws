#!/bin/bash
set -e
apt update -y
apt install -y apache2 php php-mysql php-gd php-xml php-mbstring php-curl php-zip php-cli nfs-common unzip
systemctl enable apache2
systemctl start apache2

echo "Montando NFS"
NFS_PATH="10.0.2.50:/wordpress"
MOUNT_DIR="/var/www/html"
mkdir -p /var/www/html
mount -t nfs 10.0.2.50:/wordpress /var/www/html
# Añadir a /etc/fstab para montaje automático
echo "10.0.2.50:/wordpress /var/www/html nfs defaults 0 0" >> /etc/fstab

echo "=== Instalando WordPress ==="

cd /tmp
curl -O https://wordpress.org/latest.zip
unzip latest.zip
# Copiar WordPress al directorio compartido
cp -r wordpress/* /var/www/html
# Ajustar permisos
chown -R www-data:www-data /var/www/html

echo "Wordpress instalado"
