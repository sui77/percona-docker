#!/bin/bash

# Generate random password for application & replication
APPLICATION_PW=`openssl rand -hex 20`
REPLICATION_PW=`openssl rand -hex 20`
ROOT_PW=`openssl rand -hex 20`

echo "APPLICATION_PW = ${APPLICATION_PW}"
echo "REPLICATION_PW = ${REPLICATION_PW}"
echo "ROOT_PW = ${ROOT_PW}"

# Create user + database
echo "Creating user application"
mysql -u root --password="initpassword" -e "CREATE USER 'application'@'%' IDENTIFIED BY '$APPLICATION_PW';"
mysql -u root --password="initpassword" -e "CREATE DATABASE application;";
mysql -u root --password="initpassword" -e "GRANT ALL PRIVILEGES ON application.* TO 'application'@'%'";

echo "Creating user replication"
mysql -u root --password="initpassword" -e "CREATE USER 'replication'@'%' IDENTIFIED BY '$REPLICATION_PW';"
mysql -u root --password="initpassword" -e "GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%';"

echo "Lock admin user from remote access"
mysql -u root --password="initpassword" -e "ALTER USER 'root'@'%' IDENTIFIED BY '$ROOT_PW';"
mysql -u root --password="initpassword" -e "ALTER USER 'root'@'%' IDENTIFIED BY '';"

echo "Setting kubernetes secret"
kubectl create secret generic $DBK8SNAME-credentials --namespace=$DBK8NAMESPACE --from-literal=APPLICATION_PW=$APPLICATION_PW --from-literal=REPLICATION_PW=$REPLICATION_PW
echo "Done."