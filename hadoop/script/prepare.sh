#!/bin/bash
cd ~
mkdir apps softwares data conf tmp logs
mkdir -p apps/java apps/maven apps/hadoop apps/hive apps/flume apps/zookeeper apps/scala apps/spark
mkdir -p logs/hadoop logs/zookeeper logs/yarn
mkdir -p tmp/hadoop
mkdir -p data/hdfs/hdfs_nn_dir data/hdfs/hdfs_dn_dir data/yarn_nm