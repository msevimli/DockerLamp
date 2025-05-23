FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV MYSQL_ROOT_PASSWORD=root
ENV PHPMYADMIN_VERSION=5.2.1

# Update system and install packages
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysql \
    libapache2-mod-php \
    mysql-server \
    unzip \
    wget \
    curl \
    git \
    nano \
    php-zip \
    php-mbstring \
    php-bcmath \
    php-json \
    php-curl \
    php-xml \
    php-intl \
    php-gd \
    php-mysqli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod php8.3 && a2enmod rewrite

# Setup MySQL permissions
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 755 /var/run/mysqld

# Install phpMyAdmin manually
RUN wget https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.zip && \
    unzip phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.zip && \
    mv phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages /var/www/phpmyadmin && \
    rm phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.zip && \
    chown -R www-data:www-data /var/www/phpmyadmin

# Copy start script

COPY start.sh /start.sh
RUN chmod +x /start.sh

COPY phpmyadmin.conf /etc/apache2/sites-available/phpmyadmin.conf
COPY php.ini /etc/php/8.3/apache2/php.ini
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /etc/apache2/sites-available/
RUN a2ensite phpmyadmin.conf

# Set working directory
WORKDIR /var/www/html

# Expose web and DB ports
EXPOSE 80 3306

# Start services
CMD ["/start.sh"]
