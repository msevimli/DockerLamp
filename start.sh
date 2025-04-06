#!/bin/bash

# Start MySQL
service mysql start

# Secure MySQL root user
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;"

# Start Apache in foreground
apache2ctl -D FOREGROUND