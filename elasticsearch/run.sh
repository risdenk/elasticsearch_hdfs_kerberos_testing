#!/usr/bin/env bash

set -u
set -e

cp -f /etc/docker-kdc/krb5.conf /etc/krb5.conf
cp -f /etc/docker-kdc/elasticsearch.keytab /usr/share/elasticsearch/config/repository-hdfs/krb5.keytab

/usr/share/elasticsearch/bin/es-docker

