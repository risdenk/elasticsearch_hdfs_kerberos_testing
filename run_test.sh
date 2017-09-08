#!/usr/bin/env bash

set -e
set -u

echo "Enable debugging for repository-hdfs and Hadoop classes"
curl --fail -i -XPUT -H 'Accept: application/json' -H 'Content-Type: application/json' "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d':' -f 2)/_cluster/settings" -d '{"transient" : { "logger.org.apache.hadoop" : "info"}}'
curl --fail -i -XPUT -H 'Accept: application/json' -H 'Content-Type: application/json' "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d':' -f 2)/_cluster/settings" -d '{"transient" : { "logger.org.elasticsearch.repositories.hdfs" : "info"}}'
echo
echo
echo "Delete HDFS Repository if exists"
curl -i -H 'Content-type: application/json' -H 'Accept: application/json' -XDELETE "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d ':' -f 2)/_snapshot/my_hdfs_repository"
echo "Add HDFS Repository"
curl --fail -i -H 'Content-type: application/json' -H 'Accept: application/json' -XPUT "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d':' -f 2)/_snapshot/my_hdfs_repository" -d '{"type": "hdfs", "settings": {"uri": "hdfs://namenode.example.com/", "path": "/tmp/my_hdfs_repository", "security.principal": "hdfs/elasticsearch.example.com@EXAMPLE.COM"}}' || docker-compose logs elasticsearch
echo
echo
echo "Check HDFS repository"
curl --fail -i -H 'Content-type: application/json' -H 'Accept: application/json' "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d':' -f 2)/_snapshot/my_hdfs_repository/_all?pretty" || docker-compose logs elasticsearch
echo
echo
echo "Create snapshot"
curl --fail -i -H 'Content-type: application/json' -H 'Accept: application/json' -XPUT "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d':' -f 2)/_snapshot/my_hdfs_repository/snapshot_1?wait_for_completion=true" || docker-compose logs elasticsearch
echo
echo
echo "Check HDFS repository"
curl --fail -i -H 'Content-type: application/json' -H 'Accept: application/json' "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d':' -f 2)/_snapshot/my_hdfs_repository/_all?pretty" || docker-compose logs elasticsearch
echo

