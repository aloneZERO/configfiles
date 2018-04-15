#!/bin/bash
nohup hive --service metastore >> /home/hadoop/logs/hive/metastore.log 2>&1 &
echo $! > /home/hadoop/logs/hive/hive-metastore.pid
