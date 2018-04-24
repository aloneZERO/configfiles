#!/bin/bash

ssh_login(){
    case $1 in
        1) printf "Starting login hadoop@172.31.151.$2\n"
            ssh hadoop@172.31.151.$2
        ;;
        2) printf "Starting login hadoop@10.0.1.$2\n"
            ssh hadoop@10.0.1.$2
        ;;
        o) printf "Starting login OpenStack\n"
            ssh iii@172.31.119.105
        ;;
        h) printf "ssh_login 1 <num>: ssh hadoop@172.31.151.<num>\n"
            printf "ssh_login 2 <num>: ssh hadoop@10.0.1.<num>\n"
            printf "ssh_login o: ssh login to OpenStack-VM\n"
        ;;
    esac
}

export -f ssh_login
