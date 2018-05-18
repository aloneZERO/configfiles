#!/bin/bash

case $1 in
    1) printf "Starting login hadoop@172.31.151.$2\n"
        ssh hadoop@172.31.151.$2
    ;;
    2) printf "Starting login hadoop@10.0.1.$2\n"
        ssh hadoop@10.0.1.$2
    ;;
    o) printf "Starting login other@172.31.233.$2\n"
        ssh iii@172.31.233.$2
    ;;
    h) printf "ssh_login 1 <n>: ssh hadoop@172.31.151.<n>\n"
       printf "ssh_login 2 <n>: ssh hadoop@10.0.1.<n>\n"
       printf "ssh_login o <n>: ssh other@172.31.233.<n>\n"
    ;;
esac
