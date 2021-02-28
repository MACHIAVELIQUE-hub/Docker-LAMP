FROM debian:jessie

LABEL Maintainer = JDK <jeand98.jd@gmail.com> \ 
      Description = "This is a VLAMP's image made with love by IT4"

# MAJ et prerequis
ENV MYSQL_USER=mysql \
    MYSQL_VERSION=5.5 \
    MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_RUN_DIR=/run/mysqld \
    MYSQL_LOG_DIR=/var/log/mysql \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get -y install nano \
    && apt-get -y install unzip \ 
    && mkdir /vtiger

# APACHE 2
RUN apt-get -y install apache2 \
    && a2enmod rewrite
COPY vtiger.conf /etc/apache2/sites-available
RUN a2ensite vtiger.conf \
    && service apache2 restart

# MYSQL 5.5
RUN apt-get install -y mysql-server
COPY mysql_secure.sh /vtiger

# PHP 5
RUN apt-get -y install ca-certificates \
    && apt-get -y install apt-transport-https
    
RUN echo "deb https://packages.sury.org/php/ jessie main" >> /etc/apt/sources.list
ADD https://packages.sury.org/php/apt.gpg /etc/apt/trusted.gpg.d/php.gpg 
RUN cd /etc/apt/trusted.gpg.d \
    &&  apt-key add php.gpg \
    && apt-get update
RUN apt-get -y install php5 \
    &&  apt-get -y install libapache2-mod-php5 \
    &&  apt-get -y install php5-mysql \
    &&  apt-get -y install php5-ldap \
    &&  apt-get -y install php-mbstring \
    &&  apt-get -y install php-xml \
    &&  apt-get -y install php-zip \
    &&  apt-get -y install php-pear \
    &&  apt-get -y install php5-mcrypt \
    &&  apt-get -y install php5-cli \
    &&  apt-get -y install php-soap \
    &&  apt-get -y install php5-json
RUN php5enmod pdo_mysql \
    && php5enmod ldap \
    && service apache2 restart

# Configuration de php.ini 
RUN sed -i 's/display_errors =/display_errors = On/' /etc/php5/apache2/php.ini \
    && sed -i 's/max_execution_time =/max_execution_time = 0/' /etc/php5/apache2/php.ini \
    && sed -i 's/error_reporting =/error_reporting = E_WARNING & ~E_NOTICE/' /etc/php5/apache2/php.ini \
    && sed -i 's/log_errors =/log_errors = Off/' /etc/php5/apache2/php.ini \
    && sed -i 's/short_open_tag =/short_open_tag = On/' /etc/php5/apache2/php.ini \
    && sed -i 's/upload_max_filesize =/upload_max_filesize = 5M/' /etc/php5/apache2/php.ini \
    && sed -i 's/max_input_vars =/max_input_vars = 10000/' /etc/php5/apache2/php.ini \
    && sed -i 's/memory_limit =/memory_limit = 512M/' /etc/php5/apache2/php.ini \
    && sed -i 's/post_max_size =/post_max_size = 128M/' /etc/php5/apache2/php.ini \
    && sed -i 's/max_input_time =/max_input_time = 120/' /etc/php5/apache2/php.ini \
    && sed -i 's/output_buffering =/output_buffering = On/' /etc/php5/apache2/php.ini \
    && sed -i 's/output_buffering =/output_buffering = On/' /etc/php5/apache2/php.ini \ 
    && sed -i '$ a / upload_max_size = 5M ' /etc/php5/apache2/php.ini \
    && sed -i '$ a / register_globals = Off ' /etc/php5/apache2/php.ini \ 
    && sed -i '$ a / allow_call_time_reference = On ' /etc/php5/apache2/php.ini \
    && sed -i '$ a / safe_mode = Off ' /etc/php5/apache2/php.ini \
    && sed -i '$ a / suhosin.simulation = On ' /etc/php5/apache2/php.ini \
    && sed -i '$ a / file_uploads = On' /etc/php5/apache2/php.ini \
    && service apache2 restart

# VTIGER
COPY vtigercrm.zip /vtiger
RUN cd /vtiger \
    && unzip vtigercrm.zip -d /var/www/ \
    && chmod -R 0775 /var/www/vtigercrm \
    && chown -R www-data:www-data /var/www/vtigercrm \
    && service mysql restart

WORKDIR /

EXPOSE 80/tcp

CMD service mysql start && service apache2 start 







 