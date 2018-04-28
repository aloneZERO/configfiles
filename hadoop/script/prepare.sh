#!/bin/bash
cd ~
mkdir apps softwares storage conf tmp logs workload
mkdir -p apps/java apps/maven apps/scala \
         apps/hadoop apps/hive apps/flume \
         apps/zookeeper  apps/spark
mkdir -p logs/hadoop logs/zookeeper logs/yarn logs/hive
mkdir -p tmp/hadoop
mkdir -p storage/data/hdfs/hdfs_nn_dir \
         storage/data/hdfs/hdfs_dn_dir \
         storage/data/yarn_nm \
         storage/data/spark/rdds_shuffle