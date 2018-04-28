#!/bin/bash
LOG_PATH=$HADOOP_HOME/logs

printf "=== Clean hadoop logs  ===\n"
ls $LOG_PATH
rm $LOG_PATH/*
