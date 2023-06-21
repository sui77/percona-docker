#!/bin/bash

if [ "$1" == "" ]; then
  echo ""
  echo "Usage: ./restore.bash user@host:/path/to/backup.tar.gz"
  echo ""
  exit 1
fi

BACKUP_FROM=$1

scp $BACKUP_FROM /tmp/restore.tar.gz
if [ $? -ne 0 ]; then
  echo "### Could not copy backup file"
  exit 1
fi


print -v DATE_NOW '%(%Y-%m-%d-%H%M%S)T\n' -1

mv /data/pv/mysql /data/pv/mysql-before-restore-$DATE_NOW
mkdir /data/pv/mysql

mkdir /tmp/restore && tar xzvf /tmp/restore.tar.gz -C /tmp/restore

xtrabackup --prepare --target-dir=/tmp/restore
xtrabackup --copy-back --target-dir=/tmp/restore --datadir=/data/pv/mysql

echo "### Restore complete. Please deploy the "database" deployment via deploytool"
