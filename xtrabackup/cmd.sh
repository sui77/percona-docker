#!/bin/sh

# Install ssh keys if present
if test -f "/data/sshkey/id_rsa"; then
    mkdir -p ~/.ssh
    cp /data/sshkey/* ~/.ssh
    chmod 600 ~/.ssh/*
fi

if [ -z ${CRON_SCHEDULE} ]; then
    out_error "Missing env CRON_SCHEDULE"
    exit 1
fi


echo "Installing cron..."

#crontab -e | { cat; echo "${CRON_SCHEDULE} mysql echo \"Hello\" "; } | crontab -
(crontab -l 2>/dev/null; echo "${CRON_SCHEDULE} /run-db-backup.sh -with args") | crontab -

echo "Installing cron done."

/usr/sbin/crond -n