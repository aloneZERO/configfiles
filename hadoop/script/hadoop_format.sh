#!/bin/bash

DATA_ROOT=/home/hadoop/data

printf "=== Delete hdfs data ===\n\n"
ls $DATA_ROOT/hdfs/hdfs_dn_dir/
ls $DATA_ROOT/hdfs/hdfs_nn_dir/
rm -rf $DATA_ROOT/hdfs/hdfs_dn_dir/*
rm -rf $DATA_ROOT/hdfs/hdfs_nn_dir/*

printf "\n=== Delete yarn node manager data ===\n\n"
ls $DATA_ROOT/yarn_nm/
rm -rf $DATA_ROOT/yarn_nm/*
