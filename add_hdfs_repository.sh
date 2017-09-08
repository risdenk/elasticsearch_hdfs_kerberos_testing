#!/usr/bin/env bash

curl -i -H 'Content-type: application/json' -H 'Accept: application/json' -XPUT "http://localhost:$(docker-compose port elasticsearch 9200 | cut -d':' -f 2)/_snapshot/my_hdfs_repository" -d '{"type": "hdfs", "settings": {"uri": "hdfs://namenode.example.com/", "path": "/tmp/my_hdfs_repository", "security.principal": "hdfs/elasticsearch.example.com@EXAMPLE.COM"}}'

