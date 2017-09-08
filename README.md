# Elasticsearch HDFS Kerberos Testing

[![Build Status](https://travis-ci.org/risdenk/elasticsearch_hdfs_kerberos_testing.svg?branch=master)](https://travis-ci.org/risdenk/elasticsearch_hdfs_kerberos_testing)

## Getting Started
1. `docker network create example.com`
2. `docker-compose up -d`
3. `./run_test.shh`
5. `docker-compose down -v --remove-orphans --rmi=all`
6. `docker network rm example.com`

## Development
1. `docker-compose -f docker-compose.yml -f docker-compose-dev.yml build`
2. `docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d`
3. Check the URLs above.

## References
* https://github.com/elastic/elasticsearch/issues/26513

