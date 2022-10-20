FROM percona:8.0.29-21-centos AS perconaRsync

USER root
RUN yum update && yum -y install

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

FROM percona/percona-xtrabackup:8.0.29 AS perconaXtrabackup

FROM perconaRsync

ENV MYSQL_ROOT_PASSWORD=initpassword
ENV MYSQL_ALLOW_EMPTY_PASSWORD=true
COPY --from=perconaXtrabackup /usr/bin/xtrabackup /usr/bin/xtrabackup
RUN chmod 755 /usr/bin/xtrabackup

COPY after-initdb.sh /docker-entrypoint-initdb.d/after-initdb.sh
RUN chmod 777 /docker-entrypoint-initdb.d/after-initdb.sh
USER mysql
