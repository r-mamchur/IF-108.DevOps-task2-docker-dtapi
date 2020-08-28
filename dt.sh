#!/bin/bash

export MYSQL_ROOT_PASSWORD=Passw0rd
export MYSQL_DATABASE=dtapi
export MYSQL_USER='dtapi' 
export MYSQL_PASSWORD='Passw0rd('
export MYSQL_NAME='my-container'
export DT_BE_HOME=$(pwd)/_data/dtapi/api

#---------------------------------------- back-end start

/bin/wget https://github.com/koseven/koseven/archive/master.zip
unzip master.zip && rm master.zip
mv -f ./koseven-master/* $DT_BE_HOME
rm -rf ./koseven-master
git clone https://github.com/yurkovskiy/dtapi
yes|cp -fr ./dtapi/* $DT_BE_HOME
cp ./dtapi/.htaccess $DT_BE_HOME/.htaccess
rm -rf ./dtapi
cp $DT_BE_HOME/public/index.php $DT_BE_HOME/index.php

sed -i -e "s|'base_url'   => '/',|'base_url'   => '/api/',|g"  $DT_BE_HOME/application/bootstrap.php
sed -i -e "s|RewriteBase /|RewriteBase /api/|g"  $DT_BE_HOME/.htaccess
sed -i -e "s|$tableName = \"groups\";|$tableName = \"dt_groups\";|g"  $DT_BE_HOME/application/classes/Model/Group.php
sed -i -e "s|PDO_MySQL|PDO|g"  $DT_BE_HOME/application/config/database.php
sed -i -e "s|localhost;dbname=dtapi2|$MYSQL_NAME;dbname=dtapi|g"  $DT_BE_HOME/application/config/database.php
sed -i -e "s|'password'   => 'dtapi'|'password'   => '$MYSQL_PASSWORD'|g"  $DT_BE_HOME/application/config/database.php

chown 48:48 $DT_BE_HOME -R
chmod 777 -R $DT_BE_HOME
#---------------------------------------- back-end finish

docker run --name $MYSQL_NAME  \
  -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  -e MYSQL_DATABASE=$MYSQL_DATABASE \
  -e MYSQL_USER=$MYSQL_USER \
  -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
  -v $(pwd)/init_db:/docker-entrypoint-initdb.d  \
  -v $(pwd)/_data/mysql_home:/var/lib/mysql \
  --rm -d mysql \
  --default-authentication-plugin=mysql_native_password

docker build -t "dt_be:8" .

docker run -v $DT_BE_HOME:/var/www/dtapi/api \
   -h be \
   --name be-container \
   -p 80:80 \
   --link $MYSQL_NAME \
   --rm -d dt_be:8
   