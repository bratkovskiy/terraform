#!/bin/bash

# Обновляем пакеты и устанавливаем MySQL
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y mysql-server

# Запускаем MySQL
sudo systemctl start mysql
sudo systemctl enable mysql

# Настраиваем root пароль
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${ROOT_PASSWORD}';"

# Разрешаем подключения извне
sudo sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Перезапускаем MySQL
sudo systemctl restart mysql

# Создаем базу и пользователя если указаны
if [ ! -z "${DATABASE}" ] && [ ! -z "${USER}" ] && [ ! -z "${PASSWORD}" ]; then
    sudo mysql -u root -p"${ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS ${DATABASE};"
    sudo mysql -u root -p"${ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${USER}'@'%' IDENTIFIED BY '${PASSWORD}';"
    sudo mysql -u root -p"${ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON ${DATABASE}.* TO '${USER}'@'%';"
    sudo mysql -u root -p"${ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
fi
