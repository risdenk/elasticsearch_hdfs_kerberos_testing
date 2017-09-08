FROM uhopper/hadoop-datanode:2.7.2

ADD http://www.apache.org/dist/bigtop/bigtop-1.2.0/repos/ubuntu16.04/bigtop.list /etc/apt/sources.list.d/bigtop.list

RUN apt-get update && apt-get install -y --force-yes bigtop-jsvc && rm -rf /var/lib/apt/lists/* && apt-get clean

