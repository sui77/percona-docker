#!/bin/bash

FILENAME="backup-$(date +%Y-%m-%d-%H-%M)"
xtrabackup --backup --datadir=/var/lib/mysql/ --target-dir=/backups/$FILENAME

cd /backups
tar -czvf $FILENAME.tar.gz -C /backups/$FILENAME .

rm -rf /backups/$FILENAME

rsync -avz /backups/ $RSYNC_TO

rm -rf /backups/$FILENAME.tar.gz