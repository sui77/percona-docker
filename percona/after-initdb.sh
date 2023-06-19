#!/bin/bash

# Generate random password for application & replication
APPLICATION_PW=`openssl rand -hex 20`
ROOT_PW=`openssl rand -hex 20`

echo "APPLICATION_PW = ${APPLICATION_PW}"
echo "ROOT_PW = ${ROOT_PW}"

# Create user + database
echo "Creating user application"
mysql -u root --password="initpassword" -e "CREATE USER 'application'@'%' IDENTIFIED BY '$APPLICATION_PW';"
mysql -u root --password="initpassword" -e "CREATE DATABASE application;";
mysql -u root --password="initpassword" -e "GRANT ALL PRIVILEGES ON application.* TO 'application'@'%'";
mysql -u root --password="initpassword" -e "ALTER USER 'application'@'%' IDENTIFIED WITH mysql_native_password BY '$APPLICATION_PW'";

echo "Lock admin user from remote access"
mysql -u root --password="initpassword" -e "ALTER USER 'root'@'%' IDENTIFIED BY '$ROOT_PW';"
mysql -u root --password="initpassword" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '';"

echo "Setting kubernetes secret"
if [ ! -z ${DBK8SNAME} ]; then
  kubectl create secret generic $DBK8SNAME-credentials --namespace=$DBK8NAMESPACE --from-literal=APPLICATION_PW=$APPLICATION_PW --from-literal=ROOT_PW=$ROOT_PW
else
  echo "DBK8SNAME not set, skipping."
fi
echo "Done."
