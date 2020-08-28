#!/bin/bash

if [ ! -d $(pwd)/_data ]; then 
   mkdir $(pwd)/_data
   mkdir $(pwd)/_data/mysql_home
   mkdir $(pwd)/_data/dtapi
   mkdir $(pwd)/_data/dtapi/api
   chmod 777 $(pwd)/_data -R

fi