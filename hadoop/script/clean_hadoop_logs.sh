#!/bin/bash
target=$HADOOP_HOME/logs

echo -e "=== Clean hadoop logs  ===\n"
ls $target
rm $target/*
