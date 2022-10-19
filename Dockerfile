FROM percona:8.0.29-21-centos AS perconaRsync

USER root
RUN yum update && yum -y install rsync

FROM perconaRsync

ENV MYSQL_ALLOW_EMPTY_PASSWORD true
COPY after-initdb.sh /docker-entrypoint-initdb.d/after-initdb.sh
RUN chmod 755 /docker-entrypoint-initdb.d/after-initdb.sh
USER mysql
