FROM centos:7

RUN yum install yum-utils mc httpd -y

RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
 && yum-config-manager --enable remi-php73 \
 && yum install -y epel-release \
 && yum install -y php php-zip php-gd php-intl php-mbstring php-soap php-xmlrpc \
      php-opcache php-mysqli php-http php-pdo_mysql php73-php-fpm php73-php-gd \
      php73-php-mbstring php73-php-mysqlnd \
 && yum clean all
 
# RUN mkdir /var/www/dtapi && mkdir /var/www/dtapi/api 

RUN echo '<VirtualHost *:80> ' > /etc/httpd/conf.d/dtapi.conf  && \
    echo '  DocumentRoot /var/www/dtapi ' >> /etc/httpd/conf.d/dtapi.conf  && \
    echo '  ErrorLog /var/log/httpd/dtapi_error.log ' >> /etc/httpd/conf.d/dtapi.conf  && \
    echo '  CustomLog /var/log/httpd/dtapi_requests.log combined ' >> /etc/httpd/conf.d/dtapi.conf  && \
    echo '  <Directory /var/www/dtapi/> ' >> /etc/httpd/conf.d/dtapi.conf  && \
    echo '     AllowOverride All ' >> /etc/httpd/conf.d/dtapi.conf  && \
    echo '  </Directory> ' >> /etc/httpd/conf.d/dtapi.conf  && \
    echo '</VirtualHost>' >> /etc/httpd/conf.d/dtapi.conf

EXPOSE 80

#USER apache

ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]