#!/usr/bin/env bash

set -e
set -u
#set -x

HDFS_CONFIGS="\"conf.dfs.nameservices\": \"mycluster\",\"conf.dfs.client.failover.proxy.provider.mycluster\": \"org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider\",\"conf.dfs.ha.namenodes.mycluster\": \"nn1,nn2\",\"conf.dfs.namenode.rpc-address.mycluster.nn1\": \"namenode.example.com:8020\",\"conf.dfs.namenode.http-address.mycluster.nn1\": \"namenode.example.com:50070\",\"conf.dfs.namenode.rpc-address.mycluster.nn2\": \"namenode2.example.com:8020\",\"conf.dfs.namenode.http-address.mycluster.nn2\": \"namenode2.example.com:50070\""

echo "Wait for Elasticsearch cluster to be ready"
wget --retry-connrefused --tries=12 -q --wait=5 --spider "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d':' -f2)"
curl --fail -i -XGET -H 'Accept: application/json' -H 'Content-Type: application/json' "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d':' -f 2)/_cluster/health?wait_for_status=yellow&timeout=120s"
echo
echo
echo "Enable debugging for repository-hdfs and Hadoop classes"
curl --fail -i -XPUT -H 'Accept: application/json' -H 'Content-Type: application/json' "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d':' -f 2)/_cluster/settings" -d '{"transient" : { "logger.org.apache.hadoop" : "info"}}'
curl --fail -i -XPUT -H 'Accept: application/json' -H 'Content-Type: application/json' "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d':' -f 2)/_cluster/settings" -d '{"transient" : { "logger.org.elasticsearch.repositories.hdfs" : "info"}}'
echo
echo
echo "Delete HDFS Repository if exists"
curl -i -H 'Content-type: application/json' -H 'Accept: application/json' -XDELETE "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d ':' -f 2)/_snapshot/my_hdfs_repository"
echo
echo
echo "Add HDFS Repository"
curl --fail -i -H 'Content-type: application/json' -H 'Accept: application/json' -XPUT "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d':' -f 2)/_snapshot/my_hdfs_repository" -d "{\"type\": \"hdfs\", \"settings\": {${HDFS_CONFIGS}, \"uri\": \"hdfs://mycluster/\", \"path\": \"/tmp/my_hdfs_repository\", \"security.principal\": \"hdfs/elasticsearch.example.com@EXAMPLE.COM\"}}" || docker-compose logs elasticsearch
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
echo
echo "Delete HDFS Repository"
curl --fail -i -H 'Content-type: application/json' -H 'Accept: application/json' -XDELETE "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d ':' -f 2)/_snapshot/my_hdfs_repository" || docker-compose logs elasticsearch
echo
echo
echo "Add 2nd HDFS Repository"
curl --fail -i -H 'Content-type: application/json' -H 'Accept: application/json' -XPUT "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d':' -f 2)/_snapshot/readonly_hdfs_repository" -d "{\"type\": \"hdfs\", \"settings\": {${HDFS_CONFIGS}, \"uri\": \"hdfs://mycluster/\", \"path\": \"/tmp/my_hdfs_repository\", \"security.principal\": \"hdfs/elasticsearch.example.com@EXAMPLE.COM\", \"readonly\": true}}" || docker-compose logs elasticsearch
echo
echo
echo "Check HDFS repository"
curl --fail -i -H 'Content-type: application/json' -H 'Accept: application/json' "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d':' -f 2)/_snapshot/readonly_hdfs_repository/_all?pretty" || docker-compose logs elasticsearch
echo
curl --fail -i -H 'Content-type: application/json' -H 'Accept: application/json' -XDELETE "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d ':' -f 2)/_snapshot/readonly_hdfs_repository" || docker-compose logs elasticsearch
echo

