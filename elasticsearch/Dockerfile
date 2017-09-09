FROM docker.elastic.co/elasticsearch/elasticsearch:6.0.0-rc1

USER root

RUN bin/elasticsearch-plugin install -b repository-hdfs && mkdir -p /usr/share/elasticsearch/config/repository-hdfs && chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/config/

RUN touch /etc/krb5.conf && chown elasticsearch:elasticsearch /etc/krb5.conf

USER elasticsearch

ADD run.sh /run.sh

CMD ["/bin/bash", "/run.sh"]

