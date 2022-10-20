#!/bin/bash

FILENAME="backup-$(date +%Y-%m-%d-%H-%M)"
xtrabackup --backup --datadir=/var/lib/mysql/ --target-dir=/backups/$FILENAME &> /backups/backup.txt

cd /backups
tar -czvf $FILENAME.tar.gz -C /backups/$FILENAME . &> /backups/backup.txt

rm -rf /backups/$FILENAME

rsync -avz /backups/ $RSYNC_TO &> /backups/backup.txt

rm -rf /backups/$FILENAME.tar.gz

mv /backups/backup.txt /backups/backup_prev.txt