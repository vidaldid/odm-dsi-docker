#!/bin/bash

set -e

function print_usage() {
        echo "$0 <DSI_CONTAINER_NAME>"
}

if [ -z "$1" ]; then
        print_usage
        exit 1
fi

docker exec $1 /opt/dsi/runtime/wlp/bin/xscmd.sh -c showMapSizes -cep $CONTAINER_IP:2809 -g com.ibm.ia -ms iaMaps -user test -pwd tester
