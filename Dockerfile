FROM percona:8.0.29-21-centos

RUN yum update && yum install \
    ssh-client

COPY after-initdb.sh /docker-entrypoint-initdb.d/after-initdb.sh
RUN chmod 700 /docker-entrypoint-initdb.d/after-initdb.sh