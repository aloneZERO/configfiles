#!/bin/bash

prefix=/home/hadoop/data

echo -e "=== Delete hdfs data ===\n\n"
ls $prefix/hdfs/hdfs_dn_dir/
ls $prefix/hdfs/hdfs_nn_dir/
rm -rf $prefix/hdfs/hdfs_dn_dir/*
rm -rf $prefix/hdfs/hdfs_nn_dir/*

echo -e "\n=== Delete yarn node manager data ===\n\n"
ls $prefix/yarn_nm/
rm -rf $prefix/yarn_nm/*
