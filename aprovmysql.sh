#!/bin/bash
set -e
echo "Instalando Mariadb"
apt update -y
apt install -y mariadb-server
systemctl enable mariadb
systemctl start mariadb
echo "Configurando base de datos"

mysql -e "CREATE DATABASE wordpress;"
mysql -e "CREATE USER 'wpuser'@'%' IDENTIFIED BY '1234';"
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';"
mysql -e "FLUSH PRIVILEGES;"

echo "Servidor instalado correctamente"
