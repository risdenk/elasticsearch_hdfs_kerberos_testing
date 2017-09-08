FROM docker.elastic.co/elasticsearch/elasticsearch:5.5.2

USER root

RUN bin/elasticsearch-plugin install -b repository-hdfs && mkdir -p /usr/share/elasticsearch/config/repository-hdfs && chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/config/

RUN wget -O /usr/share/elasticsearch/plugins/repository-hdfs/log4j-slf4j-impl-2.8.2.jar http://central.maven.org/maven2/org/apache/logging/log4j/log4j-slf4j-impl/2.8.2/log4j-slf4j-impl-2.8.2.jar

RUN touch /etc/krb5.conf && chown elasticsearch:elasticsearch /etc/krb5.conf

USER elasticsearch

ADD run.sh /run.sh

CMD ["/bin/bash", "/run.sh"]


