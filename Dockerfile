FROM percona:8.0.29-21-centos AS perconaRsync

USER root
RUN yum update && yum -y install rsync

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

FROM perconaRsync

ENV MYSQL_ROOT_PASSWORD=initpassword
COPY after-initdb.sh /docker-entrypoint-initdb.d/after-initdb.sh
RUN chmod 777 /docker-entrypoint-initdb.d/after-initdb.sh
USER mysql
