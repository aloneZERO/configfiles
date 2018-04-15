#!/bin/bash
nohup hive --service hiveserver2 >> /home/hadoop/logs/hive/hiveserver.log 2>&1 &
echo $! > /home/hadoop/logs/hive/hive-server.pid
