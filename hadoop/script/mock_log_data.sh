#!/bin/sh

function random() {
  echo $(($RANDOM%$1+1))
}

d="."
ext=".txt"

#file_date=`date --date="-24 hour" +%Y-%m-`
#file_day=`date --date="-24 hour" +%d`+1

file_date=$(date +%Y-%m-%d)
file_name=$file_date$file_day$ext

for i in {1..1000}
do 
    ip_1=$(random  253)$d
    ip_2=$(random  253)$d
    ip_3=$(random  253)$d
    ip_4=$(random 253) 

    access_cnt=$(random 100)    
    access_time=$(date +%Y%-m%-d%H:%M:%S)
    echo -e "$i,$ip_1$ip_2$ip_3$ip_4,$access_time,$access_cnt\n">>$file_name
done;
