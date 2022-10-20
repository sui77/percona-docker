#!/bin/bash

FILENAME="backup-$(date +%Y-%m-%d-%H-%M)"
xtrabackup --backup --datadir=/var/lib/mysql/ --target-dir=/backups/$FILENAME &> /backup.txt

cd /backups
tar -czvf $FILENAME.tar.gz -C /backups/$FILENAME . &> /backup.txt

rm -rf /backups/$FILENAME

rsync -avz /backups/ $RSYNC_TO &> /backup.txt

rm -rf /backups/$FILENAME.tar.gz