#!/bin/bash

pcount=$#
if (($pcount<2));then
  echo 'Usage: x-sync.sh <local_file_path> <remote_file_path>';
  exit;
fi

src=$1
dest=$2
for ((host=1;host<=2;host++))do
  echo '-------Slave'$host'--------'
  scp $src hadoop@Slave$host:$dest;
done

