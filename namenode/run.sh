#!/bin/bash

cp -f /etc/docker-kdc/krb5.conf /etc/krb5.conf

namedir=`echo $HDFS_CONF_dfs_namenode_name_dir | perl -pe 's#file://##'`
if [ ! -d $namedir ]; then
  echo "Namenode name directory not found: $namedir"
  exit 2
fi

editsdir=`echo $HDFS_CONF_dfs_namenode_shared_edits_dir | perl -pe 's#file://##'`
if [ ! -d $editsdir ]; then
  echo "Namenode edits directory not found: $editsdir"
  exit 2
fi

if [ -z "$CLUSTER_NAME" ]; then
  echo "Cluster name not specified"
  exit 2
fi

if [ "$(ls -A $namedir)" == "" ] && [ "$(ls -A $editsdir)" == "" ]; then
  echo "Formatting namenode name directory: $namedir"
  $HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME -nonInteractive || (sleep 10 && $HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode -bootstrapStandby && sleep 5 && (kinit -kt /etc/docker-kdc/nn.service.keytab hdfs/$(hostname -f)@EXAMPLE.COM || kinit -kt /etc/docker-kdc/nn2.service.keytab hdfs/$(hostname -f)@EXAMPLE.COM) && $HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR haadmin -transitionToActive --forceactive nn1 && kdestroy) 
fi

$HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode
