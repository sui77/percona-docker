#!/bin/sh

# Generate random password for application & replication
APPLICATION_PW=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c24`
REPLICATION_PW=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c24`

echo "APPLICATION_PW = ${APPLICATION_PW}"
echo "REPLICATION_PW = ${REPLICATION_PW}"

# Create user + database
mysql -u root --password="" -e "CREATE USER 'application'@'%' IDENTIFIED BY '$APPLICATION_PW';"
mysql -u root --password="" -e "CREATE DATABASE application";
mysql -u root --password="" -e "GRANT ALL PRIVILEGES ON application TO 'application'@'%'";
mysql -u root --password="" -e "GRANT REPLICATION SLAVE ON *.*  TO 'replication'@'%' IDENTIFIED BY '$REPLICATION_PW'";



kubectl create secret generic $DBK8SNAME-credentials --namespace=$DBK8NAMESPACE --from-literal=APPLICATION_PW=$APPLICATION_PW --from-literal=REPLICATION_PW=$REPLICATION_PW
echo "Done."