FROM percona/percona-xtrabackup:8.0

USER root
RUN whoami
RUN microdnf -y install cronie vi tar

COPY ./run-db-backup.sh /run-db-backup.sh
COPY ./cmd.sh /cmd.sh
RUN chmod +x /*.sh


#ENTRYPOINT /entrypoint.sh
CMD /cmd.sh